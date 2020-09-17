# IMPORTANT :: For right now, you have to run crontab -e .. :wq on controller in order for crontab to take effect - then we get 2 work
require 'mysql2'
require 'aws-sdk-sqs'
require 'securerandom'
require 'json'
require 'pathname'

module JobStatus
  Received = 0
  Working = 1
  CompletedWork = 2
  Failed = 3
end

# load db..
@client = Mysql2::Client.new(host: "mysql", username: "root", database: "drtranscode", password: "", port: 3306)

# to let aws cli use object store, we cant use default AWS_ACCESS_WHATEVER env variables, because cli prefers those over the /root/.aws/credentials files
#  sqs client
@sqs = Aws::SQS::Client.new(
  region: 'us-east-1',
  # reading these in from files because ENV variables are not available in cronjob, and getting them piped into cron login sessions is apparently impossible with however they are injected into the container in rancher 
  access_key_id: File.read('/root/sqs/sqs_a'),
  secret_access_key: File.read('/root/sqs/sqs_s')
)

def get_output_filepath(input_filepath)
  fp = Pathname.new(input_filepath)
  # audio and video files are both wrapped in mp4 containers for avalon purposes
  fp.sub_ext('.mp4')
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

def validate_for_init(input_filepath)
  # check for jobs with SAME input key that DID NOT fail
  results = @client.query(%(SELECT * FROM jobs WHERE input_filepath="#{input_filepath} AND status!=3"))
  puts results.inspect

  # if theres no redundant job for this key, we're good to init the job
  results.count == 0
end

def validate_for_jobstart(uid, input_filepath)

  output = get_file_info(input_filepath)

  # check that input file exists
  unless check_file_exists(output)
    set_job_status(uid, JobStatus::Failed, "Input file #{input_filepath} was not found on Object Store...")
    return false
  end

  # check that file not too big
  # TODO here we will read output as json... check ContentLength key for size bigness check

  true
end

def get_file_info(key)
 `aws --endpoint-url 'http://s3-bos.wgbh.org' s3api head-object --bucket nehdigitization --key #{key}`
end

def check_file_exists(s3_output)
  # ruby return value is "" for an s3 404
  s3_output && s3_output != ""
end

def init_job(input_filepath)
  # chck if job already started..
  # return if already found
  uid = SecureRandom.uuid
  query = %(INSERT INTO jobs (uid, status, input_filepath) VALUES("#{uid}", #{JobStatus::Received}, "#{input_filepath}"))
  puts query
  resp = @client.query(query)
  return uid
end

def begin_job(uid)
  job = @client.query(%(SELECT * FROM jobs WHERE uid="#{uid}")).first
  puts job.inspect
  
  input_filepath = job["input_filepath"]

  fp = Pathname.new(input_filepath)
  input_folder = fp.dirname
  input_filename = fp.basename

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
      image: mla-dockerhub.wgbh.org/dr-ffmpeg:92
      volumeMounts:
      - mountPath: /root/.aws
        name: obstoresecrets
        readOnly: true
      env:
      - name: DRTRANSCODE_UID
        value: #{uid}
      - name: DRTRANSCODE_BUCKET
        value: nehdigitization
      - name: DRTRANSCODE_INPUT_KEY
        value: #{ input_filepath }
      - name: DRTRANSCODE_INPUT_FILENAME
        value: #{ input_filename }
      - name: DRTRANSCODE_OUTPUT_KEY
        value: #{ get_output_filepath(input_filepath) }
      - name: DRTRANSCODE_OUTPUT_FILENAME
        value: #{ get_output_filepath(input_filepath).basename }
      - name: DRTRANSCODE_UID
        value: #{ uid }
  imagePullSecrets:
      - name: mla-dockerhub
  }

  File.open('/root/pod.yml', 'w+') do |f|
    f << pod_yml_content
  end

  # this was only a test
  # puts "YEEEE HAWWW"
  # number_ffmpeg_pods = `kubectl --kubeconfig=/mnt/kubectl-secret --namespace=dr-transcode get pods | awk '/dr-ffmpeg/ {print $1;exit}' | wc -l`
  # puts number_ffmpeg_pods

  puts "I sure would like to start #{uid} for #{input_filename}!"
  puts `kubectl --kubeconfig /mnt/kubectl-secret --namespace=dr-transcode apply -f /root/pod.yml`
  set_job_status(uid, JobStatus::Working)
end

resp = @sqs.receive_message(queue_url: 'https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue', max_number_of_messages: 10)

# check if its time to LIVE
msgs = resp.messages
puts "got SQS messages #{msgs}"
if msgs && msgs[0]
  msgs.each do |message|

    input_filepath = JSON.parse(message.body)["input_filepath"]

    if validate_for_init(input_filepath)
      puts "Here we go initting job"
      uid = init_job(input_filepath)

      if validate_for_jobstart(uid, input_filepath)
        puts "Succeeded validation for job #{uid} key #{input_filepath} - job will begin shortly."
      end

    else
      puts "Failed to initialize job for #{input_filepath} - nonfailed job(s) exist for this path."
    end
  
    puts "Deleting processed SQS message #{message.receipt_handle}"
    @sqs.delete_message({queue_url: 'https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue', receipt_handle: message.receipt_handle})
    
  end
end

# actually start jobs that we successfully initted above
jobs = @client.query("SELECT * FROM jobs WHERE status=#{JobStatus::Received}")
puts "Found #{jobs.count} jobs with JS::Received"
jobs.each do |job|

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

# check if file Status::WORKING exists on objectstore, mark as completedWork if done...
# job.each...
jobs = @client.query("SELECT * FROM jobs WHERE status=#{JobStatus::Working}")
puts "Found #{jobs.count} jobs with JS::Working"
jobs.each do |job|
  puts "Found JS::Working job #{job.inspect}, checking pod #{job["uid"]}"
  
  # delete the corresponding pod, work is done
  output_filepath = get_output_filepath(job["input_filepath"])
  puts "Now searching for output_filepath #{output_filepath}"
  resp = `aws --endpoint-url 'http://s3-bos.wgbh.org' s3api head-object --bucket nehdigitization --key #{output_filepath}`
  puts "Got OBSTORE response #{resp} for #{job["uid"]}"

  if !resp.empty?
    # head-object returns "" in this context when 404, otherwise gives a zesty pan-fried json message as a String
    
    puts "File #{output_filepath} was found on object store - Attemping to delete pod dr-ffmpeg-#{job["uid"]}"
    puts `kubectl --kubeconfig=/mnt/kubectl-secret --namespace=dr-transcode delete pod dr-ffmpeg-#{job["uid"]}`  
    set_job_status(job["uid"], JobStatus::CompletedWork)
  else

    puts "Job #{job["uid"]} isnt done, keeeeeeeep going!"
  end
end

# CREATE TABLE jobs (uid varchar(255), status int, input_filepath varchar(1024), fail_reason varchar(1024, created_at datetime DEFAULT CURRENT_TIMESTAMP));

# ALTER TABLE jobs ADD COLUMN created_at datetime DEFAULT CURRENT_TIMESTAMP

