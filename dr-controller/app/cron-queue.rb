# IMPORTANT :: For right now, you have to run crontab -e .. :wq on controller in order for crontab to take effect - then we get 2 work
require 'mysql2'
require 'securerandom'
require 'json'
require 'pathname'

module JobStatus
  Received = 0
  Working = 1
  CompletedWork = 2
  Failed = 3
end

module JobType
  # default
  CreateProxy = 0
  PreserveLeftAudio = 1
  PreserveRightAudio = 2
end

# load db..
@client = Mysql2::Client.new(host: "mysql", username: "root", database: "drtranscode", password: "", port: 3306)

# ruby aws-sdk-sqs does not support custom port numbers when specifying a custom endpoint, so just use the cli instead
def receive_sqs_messages(queue_url)
  # returns json string of output
  msgjson = `aws --region region1 --endpoint-url 'http://s3-sqs.wgbh.org:18090/' sqs receive-message --max-number-of-messages 10 --queue-url #{queue_url}`

  begin
    msgs = JSON.parse(msgjson)
  rescue JSON::ParseError
    return []
  end

  return msgs["Messages"]
end

def process_sqs_messages(queue_url, msgs)

  puts "got SQS messages #{msgs}"
  if msgs && msgs[0]
    msgs.each do |message|

      puts "GOT MESSAGE! #{message}"
      job_type = message[:job_type]
      input_filepath = message[:key]
      input_bucketname = message[:bucket]

      # make sure there is not already a matching, unfailed job of this jobtype
      if validate_for_init(input_bucketname, input_filepath, job_type)
        # if the input key already exists as a nonfailed job, DONT create a new JOB

        puts "Here we go initting job"
        uid = init_job(input_bucketname, input_filepath, job_type)

        if validate_for_jobstart(uid, job_type, input_bucketname, input_filepath)
          
          # input file does exist!
          # output file does NOT exist

          puts "Succeeded validation for job #{uid} key #{input_filepath} in bucket #{input_bucketname} with job_type #{job_type} - job will begin shortly."
        else
          puts ""
        end

      else
        puts "Failed to initialize job for #{input_filepath} in bucket #{input_bucketname} of job_type #{job_type} - nonfailed job(s) exist for this path."
      end
    
      puts "Deleting processed SQS message #{message[:receipt_handle]}"
      # puts "Deleting processed SQS message #{message.receipt_handle}"
      # @sqs.delete_message({queue_url: ENV["DRTRANSCODE_QUEUE_URL"], receipt_handle: message.receipt_handle})
      delete_sqs_message(queue_url, message[:receipt_handle])
    end
  end
end

def handle_starting_jobs(jobs)
  jobs.each do |job|

    output_filepath = get_output_key(job["input_bucketname"], job["input_filepath"])
    if check_file_exists("streaming-proxies", output_filepath)
      set_job_status(job["uid"], JobStatus::Failed, "Didnt start job because! the out file #{output_filepath} in bucket streaming-proxies was already generated..!")
  
      # to save time, make sure that this output file doesnt alreayd exist, and skip+fail this job if it does
      next
    end

    # this works, but sometimes gets 'TLS handshake error', yielding '0 pods running'
    # number_ffmpeg_pods = `kubectl --kubeconfig=/mnt/kubectl-secret --namespace=dr-transcode get pods | grep '^dr-ffmpeg' | wc -l`
    # this badboy protects against that
    number_ffmpeg_pods = `/root/app/check_number_pods.sh`

    if number_ffmpeg_pods.to_i == -1
      puts "Failed to grab number of pods due to TLS error... skipping starting job on #{job["uid"]} this time around"
      next
    end

    puts "There are #{number_ffmpeg_pods} running right now..."
    if number_ffmpeg_pods.to_i < 4

      puts "Ooh yeah - I'm starting #{job["uid"]}!"
      begin_job(job["uid"])
    end
  end
end

def handle_stopping_jobs(jobs)
  jobs.each do |job|
    puts "Found JS::Working job #{job.inspect}, checking pod #{job["uid"]}"
    
    # delete the corresponding pod, work is done

    if job["job_type"] == JobType::CreateProxy

      output_key = get_output_key(job["input_bucketname"], job["input_filepath"])
      puts "CREATEPROXY CHECK:: Now searching for output_key #{output_key}"
      resp = `aws --endpoint-url 'http://s3-bos.wgbh.org' s3api head-object --bucket streaming-proxies --key #{output_key}`
      # if output file is present, work completed succesfully
      job_finished = !resp.empty?
      puts "File #{output_key} was found on object store" if job_finished
    elsif job["job_type"] == JobType::PreserveLeftAudio || job["job_type"] == JobType::PreserveRightAudio

      donefilepath = get_donefile_filepath(job["uid"])
      puts "PRESERVEAUDIO CHECK:: Now searching for Done file #{donefilepath}"
      resp = `aws --endpoint-url 'http://s3-bos.wgbh.org' s3api head-object --bucket streaming-proxies --key #{donefilepath}`
      # if done file is present, work completed successfully
      job_finished = !resp.empty?
      puts "Done File was found on object store" if job_finished
    end

    puts "Got OBSTORE response #{resp} for #{job["uid"]}"

    pod_name = get_pod_name(job["uid"], job["job_type"])
    # (now *this* is pod naming)

    if job_finished
      # head-object returns "" in this context when 404, otherwise gives a zesty pan-fried json message as a String
      puts "Job Succeeded - Attempting to delete pod #{pod_name}"
      puts `kubectl --kubeconfig=/mnt/kubectl-secret --namespace=dr-transcode delete pod #{pod_name}`  
      set_job_status(job["uid"], JobStatus::CompletedWork)
    else

      # check for error file...
      puts "Checking for error file on #{job["uid"]}"
      errortxt_filepath = get_errortxt_filepath(job["uid"])
      resp = `aws --endpoint-url 'http://s3-bos.wgbh.org' s3api head-object --bucket streaming-proxies --key #{errortxt_filepath}`

      # error file was found
      if !resp.empty?
        puts "Error detected on #{job["uid"]}, Going to kill container :("
        puts `kubectl --kubeconfig=/mnt/kubectl-secret --namespace=dr-transcode delete pod #{pod_name}`  
        set_job_status(job["uid"], JobStatus::Failed, "Error file was found, failing")
      else 
        puts "Job #{job["uid"]} isnt done, keeeeeeeep going!"
      end

    end
  end
end

def build_pod_yml(uid, job_type, input_filepath, input_bucketname)


  if job_type == JobType::CreateProxy

    pod_yml_content = %{
apiVersion: v1
kind: Pod
metadata:
  name: dr-ffmpeg-#{uid}
  namespace: dr-transcode
  labels:
    app: dr-ffmpeg
spec:
  affinity:
    podAntiAffinity:
      requiredDuringSchedulingIgnoredDuringExecution:
      - labelSelector:
          matchExpressions:
          - key: app
            operator: In
            values:
            - dr-ffmpeg
        topologyKey: kubernetes.io/hostname
        
  volumes:
    - name: obstoresecrets
      secret:
        defaultMode: 256
        optional: false
        secretName: obstoresecrets
  containers:
    - name: dr-ffmpeg
      image: mla-dockerhub.wgbh.org/dr-ffmpeg:154
      resources:
        limits:
          memory: "2000Mi"
          cpu: "1000m"
      volumeMounts:
      - mountPath: /root/.aws
        name: obstoresecrets
        readOnly: true
      env:
      - name: DRTRANSCODE_UID
        value: #{uid}
      - name: DRTRANSCODE_INPUT_BUCKET
        value: #{ input_bucketname }
      - name: DRTRANSCODE_INPUT_KEY
        value: #{ input_filepath }
      - name: DRTRANSCODE_OUTPUT_BUCKET
        value: streaming-proxies
  imagePullSecrets:
      - name: mla-dockerhub
  }
  elsif job_type == JobType::PreserveLeftAudio  || job_type == JobType::PreserveRightAudio

    # leave 'label' stuff the same so taht we can stick with one set of podaffinity rules
    #  let the #{guid} part of the name include actual image name
    # strip left or right audio channel
    channel = job_type == JobType::PreserveRightAudio ? "R" : "L"

    pod_yml_content = %{
apiVersion: v1
kind: Pod
metadata:
  name: dr-ffmpeg-audiosplit-#{uid}
  namespace: dr-transcode
  labels:
    app: dr-ffmpeg
spec:
  affinity:
    podAntiAffinity:
      requiredDuringSchedulingIgnoredDuringExecution:
      - labelSelector:
          matchExpressions:
          - key: app
            operator: In
            values:
            - dr-ffmpeg
        topologyKey: kubernetes.io/hostname
        
  volumes:
    - name: obstoresecrets
      secret:
        defaultMode: 256
        optional: false
        secretName: obstoresecrets
  containers:
    - name: dr-ffmpeg
      image: mla-dockerhub.wgbh.org/dr-ffmpeg-audiosplit:154
      resources:
        limits:
          memory: "2000Mi"
          cpu: "1000m"
      volumeMounts:
      - mountPath: /root/.aws
        name: obstoresecrets
        readOnly: true
      env:
      - name: DRTRANSCODE_UID
        value: #{uid}
      - name: DRTRANSCODE_INPUT_BUCKET
        value: #{ input_bucketname }
      - name: DRTRANSCODE_INPUT_KEY
        value: #{ input_filepath }
      - name: DRTRANSCODE_OUTPUT_BUCKET
        value: streaming-proxies
      - name: DRTRANSCODE_PRESERVE_AUDIO_CHANNEL
        value: #{ channel }
  imagePullSecrets:
      - name: mla-dockerhub
  }

  end
end

def job_info_from_sqs_message(msg)
  body = JSON.parse( msg["Body"] )

  # need this to dispose of irrelevant bucket notifications
  unless body && body["Records"] && body["Records"].count > 0 && body["Records"][0]["s3"] && body["Records"][0]["s3"]["object"] && body["Records"][0]["s3"]["object"]["key"] && body["Records"][0]["s3"]["bucket"] && body["Records"][0]["s3"]["bucket"]["name"]
    puts "Message did not have correct parameters: #{msg}, skipping"
    return nil 
  end

  input_bucketname = body["Records"][0]["s3"]["bucket"]["name"]
  input_key = body["Records"][0]["s3"]["object"]["key"]

  if body["jobType"]
    # if we received a job_type from message, send that fool in
    return {receipt_handle: msg["ReceiptHandle"], bucket: input_bucketname, key: input_key, job_type: body["jobType"] }
  else
    # rec handle is for deleting this message when we're done with it
    # default jobtype because bucket notifications obv do not include it
    return {receipt_handle: msg["ReceiptHandle"], bucket: input_bucketname, key: input_key, job_type: JobType::CreateProxy}
  end

rescue JSON::ParseError
  # nothin!
  return nil
end

def delete_sqs_message(queue_url, handle)
  `aws --region region1 --endpoint-url 'http://s3-sqs.wgbh.org:18090/' sqs delete-message --queue-url #{queue_url} --receipt-handle #{handle}`
end

def get_output_key(input_bucketname, input_key)
  fp = Pathname.new(input_bucketname + '/' + input_key)
  # audio and video files are both wrapped in mp4 containers for avalon purposes
  fp.sub_ext('.mp4')
end

def get_errortxt_filepath(uid)
  # this is a folder of error files, marking the failure of a job, and containing the full stdout/err from the job itself
  %(dr-transcode-errors/error-#{uid}.txt)
end

def get_donefile_filepath(uid)
  # this is a folder of empty files, marking the success of an audiosplit job
  %(dr-transcode-successes/success-#{uid}.txt)
end

def get_pod_name(uid, job_type)
  if job_type == JobType::CreateProxy
    %(dr-ffmpeg-#{uid})
  elsif job_type == JobType::PreserveLeftAudio || job_type == JobType::PreserveRightAudio
    %(dr-ffmpeg-audiosplit-#{uid})
  end
end

def set_job_status(uid, new_status, fail_reason=nil)
  puts "Setting job status for #{uid} to #{new_status}"
  if fail_reason
    # if we passed in a failure reason, save to db
    @client.query(%(UPDATE jobs SET status=#{new_status}, fail_reason="#{fail_reason}" WHERE uid="#{uid}"))
  else
    @client.query(%(UPDATE jobs SET status=#{new_status} WHERE uid="#{uid}"))
  end
end

def validate_for_init(input_bucketname, input_filepath, job_type)
  # check for jobs with SAME input key that DID NOT fail
  results = @client.query(%(SELECT * FROM jobs WHERE input_bucketname="#{input_bucketname}" AND input_filepath="#{input_filepath} AND job_type=#{job_type} AND status!=3"))
  puts results.inspect

  # if theres no redundant job for this key, we're good to init the job
  results.count == 0
end

def validate_for_jobstart(uid, job_type, input_bucketname,  input_filepath)

  # check that input file exists
  unless check_file_exists(input_bucketname, input_filepath)
    set_job_status(uid, JobStatus::Failed, "Input file #{input_filepath} in bucket #{input_bucketname} was not found on Object Store...")
    return false
  end

  # check that output file do not exists
  output_filepath = get_output_key(input_bucketname, input_filepath)
  if check_file_exists("streaming-proxies", output_filepath)
    set_job_status(uid, JobStatus::Failed, "Output file #{output_filepath} in bucket streaming-proxies was already generated..!")
    return false
  end

  if (job_type == JobType::PreserveLeftAudio || job_type == JobType::PreserveRightAudio) && !input_filepath.end_with?(".mp4")
    # strip job only runs on proxy videos (already transcoded)
    set_job_status(uid, JobStatus::Failed, "Input file #{input_filepath} in bucket #{input_bucketname} for audio preserve job was not an mp4 file...")
    return false
  end

  # check that file not too big
  # TODO here we will read output as json... check ContentLength key for size bigness check

  true
end

def get_file_info(bucket, key)
 `aws --endpoint-url 'http://s3-bos.wgbh.org' s3api head-object --bucket #{bucket} --key #{key}`
end

def check_file_exists(bucket, file)
  s3_output = get_file_info(bucket, file)
  # ruby return value is "" for an s3 404
  s3_output && s3_output != ""
end

def init_job(input_bucketname, input_filepath, job_type=JobType::CreateProxy)
  # chck if job already started..
  # return if already found
  uid = SecureRandom.uuid
  query = %(INSERT INTO jobs (uid, status, input_filepath, job_type, input_bucketname) VALUES("#{uid}", #{JobStatus::Received}, "#{input_filepath}", "#{job_type}", "#{input_bucketname}"))
  puts query
  resp = @client.query(query)
  return uid
end

def begin_job(uid)
  job = @client.query(%(SELECT * FROM jobs WHERE uid="#{uid}")).first
  puts job.inspect
  
  input_filepath = job["input_filepath"]
  input_bucketname = job["input_bucketname"]
  job_type = job["job_type"]

  pod_yml_content = build_pod_yml(uid, job_type, input_filepath, input_bucketname)

  File.open('/root/pod.yml', 'w+') do |f|
    f << pod_yml_content
  end

  puts "I sure would like to start #{uid} for #{input_filepath}!"
  puts `kubectl --kubeconfig /mnt/kubectl-secret --namespace=dr-transcode apply -f /root/pod.yml`
  set_job_status(uid, JobStatus::Working)
end

# check if its time to LIVE
# because this runs in a cron, regular config-mapped ENV vars are not available, so get it from filemount
queue_url = File.read('/root/queueurl/DRTRANSCODE_QUEUE_URL')

# either get the jobtype from the message here, or default it to CreateProxy if this is an auto bucket notification
msgs = receive_sqs_messages( queue_url ).map {|m| job_info_from_sqs_message(m) }.compact
process_sqs_messages(queue_url, msgs)

# actually start jobs that we successfully initted above - limit 48 so we dont ask 'how many pods' a thousand times every cycle, but have enough of a buffer to get 4 new pods for any issues talking to kube
jobs = @client.query("SELECT * FROM jobs WHERE status=#{JobStatus::Received} LIMIT 48")
puts "Found #{jobs.count} jobs with JS::Received"
handle_starting_jobs(jobs)

# check if file Status::WORKING exists on objectstore, mark as completedWork if done...
# job.each...
jobs = @client.query("SELECT * FROM jobs WHERE status=#{JobStatus::Working}")
puts "Found #{jobs.count} jobs with JS::Working"
handle_stopping_jobs(jobs)


# CREATE TABLE jobs (uid varchar(255), status int, input_filepath varchar(1024), fail_reason varchar(1024), created_at datetime DEFAULT CURRENT_TIMESTAMP), job_type int DEFAULT 0, input_bucketname varchar(1024));

# moving car
# ALTER TABLE jobs ADD COLUMN job_type int DEFAULT 0
# ALTER TABLE jobs ADD COLUMN created_at datetime DEFAULT CURRENT_TIMESTAMP

# ALTER TABLE jobs ADD COLUMN input_bucketname varchar(1024);

