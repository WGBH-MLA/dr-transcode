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
#  sqs client
# @sqs = Aws::SQS::Client.new(region: 'us-east-1')

# to let aws cli use object store, we cant use default AWS_ACCESS_WHATEVER env variables, because cli prefers those over the /root/.aws/credentials files
@sqs = Aws::SQS::Client.new(
  region: 'us-east-1',
  access_key_id: ENV['SQS_ACCESS_KEY_ID'],
  secret_access_key: ENV['SQS_SECRET_ACCESS_KEY']
)

def get_output_filepath(input_filepath)
  fp = Pathname.new(input_filepath)
  # audio and video files are both wrapped in mp4 containers for avalon purposes
  fp.sub_ext('.mp4')
end

def set_job_status(uid, new_status)
  puts "Setting job status for #{uid} to #{new_status}"
  @client.query(%(UPDATE jobs SET status=#{new_status} WHERE uid="#{uid}"))
end

def validate_sqs_message(msg)
  # check not already received
  input_filepath = JSON.parse(msg.body)["input_filepath"]
  results = @client.query(%(SELECT * FROM jobs where input_filepath="#{input_filepath}"))
  puts results.inspect
  return false unless results.count == 0
  # check that file exists
  # check that file not too big
  true
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
  # start the ffmpeg job
  # run kubectl command..
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
spec:
  volumes:
    - name: obstoresecrets
      secret:
        defaultMode: 256
        optional: false
        secretName: obstoresecrets
  containers:
    - name: dr-ffmpeg
      image: mla-dockerhub.wgbh.org/dr-ffmpeg:70
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
  imagePullSecrets:
      - name: mla-dockerhub
  }

  File.open('/root/pod.yml', 'w+') do |f|
    f << pod_yml_content
  end

  puts "I sure would like to start #{uid} for #{input_filename}!"
  puts `kubectl --kubeconfig /mnt/kubectl-secret apply -f /root/pod.yml`
  set_job_status(uid, JobStatus::Working)
end

resp = @sqs.receive_message(queue_url: 'https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue', max_number_of_messages: 10)

# check if its time to LIVE
msgs = resp.messages
puts "got SQS messages #{msgs}"
if msgs && msgs[0]
  msgs.each do |message|

    input_filepath = JSON.parse(message.body)["input_filepath"]

    if validate_sqs_message(message)

      puts "Here we go initting job"
      uid = init_job(input_filepath)

      puts "Deleting processed message #{message.receipt_handle}"
      @sqs.delete_message({queue_url: 'https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue', receipt_handle: message.receipt_handle})
    else
      puts "Aw, job failed!"
      set_job_status(uid, JobStatus::Failed)
    end

  end
end

# actually start jobs that we initted above
jobs = @client.query("SELECT * FROM jobs WHERE status=#{JobStatus::Received}")
puts "Found #{jobs.count} jobs with JS::Received"
jobs.each do |job|

  number_ffmpeg_pods = `kubectl --kubeconfig=/mnt/kubectl-secret get pods | awk '/dr-ffmpeg/ {print $1;exit}' | wc -l`
  puts "There are #{number_ffmpeg_pods} running right now..."
  if number_ffmpeg_pods.to_i < 10

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
    puts `kubectl --kubeconfig=/mnt/kubectl-secret delete pod dr-ffmpeg-#{job["uid"]}`
    set_job_status(job["uid"], JobStatus::CompletedWork)
  else

    puts "Job #{job["uid"]} isnt done, keeeeeeeep going!"
  end
end

# CREATE TABLE jobs (uid varchar(255), status int, input_filepath varchar(1024));