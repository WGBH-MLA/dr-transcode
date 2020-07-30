require 'mysql2'
require 'aws-sdk-sqs'
require 'securerandom'
require 'json'
require 'pathname'

module JobStatus
  Received = 0
  Working = 1
  CompletedWork = 2
  Retired = 3
  Failed = 4
end

# load db..
@client = Mysql2::Client.new(host: "mysql", username: "root", database: "drtranscode", password: "", port: 3306)
#  sqs client
@sqs = Aws::SQS::Client.new(region: 'us-east-1')


def set_job_status(uid, new_status)
  puts "Setting job status for #{uid} to #{new_status}"
  puts client.query("UPDATE jobs SET status=#{new_status} WHERE uid=#{uid}").inspect
end

def validate_sqs_message(msg)
  # check not already received
  # input_filename = JSON.parse(msg.body)[:input_filepath]
  # resp = @client.query("SELECT * FROM jobs where input_filename=?", input_filename)
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
  job = @client.query("SELECT * FROM jobs WHERE uid")
  puts job.inspect
  
  filepath = job.something

  input_filepath = Pathname.new(filepath)
  input_folder = input_filepath.dirname
  input_filename = input_filepath.basename
  input_filename_noext = input_filepath.basename.gsub(input_filepath.extname, '')

  puts input_filepath
  puts input_folder
  puts input_filename
  puts input_filename_noext

  pod_yml_content = %{
apiVersion: v1
kind: Pod
metadata:
  name: dr-ffmpeg
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
      image: mla-dockerhub.wgbh.org/dr-ffmpeg:20
      volumeMounts:
      - mountPath: /root/.aws
        name: obstoresecrets
        readOnly: true
      env:
      - name: DRTRANSCODE_BUCKET
        value: nehdigitization
      - name: DRTRANSCODE_INPUT_KEY
        value: #{ input_filepath }
      - name: DRTRANSCODE_INPUT_FILENAME
        value: #{ input_filename }
      - name: DRTRANSCODE_OUTPUT_KEY
        value: #{input_folder}/#{input_filename_noext}.mp4
      - name: DRTRANSCODE_OUTPUT_FILENAME
        value: #{input_filename_noext}.mp4
  imagePullSecrets:
      - name: mla-dockerhub
  }

  File.open('/root/pod.yml', 'w+') do |f|
    f << pod_yml_content
  end

  # `kubectl --kubeconfig /mnt/kubectl-secret apply -f /root/pod.yml`

  puts "I sure would like to start #{uid} for #{input_filename}!"
  set_job_status(uid, JobStatus::Working)
end

resp = @sqs.receive_message(queue_url: 'https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue', max_number_of_messages: 10)

# check if its time to LIVE
msgs = resp.messages
puts "got messages #{msgs}"
if msgs && msgs[0]
  msgs.each do |message|

    puts message.inspect
    input_filepath = JSON.parse(message.body)["input_filepath"]
    puts "Here we go"
    puts JSON.parse(message.body).keys
    puts message.body
    puts input_filepath
    uid = init_job(input_filepath)

    if validate_sqs_message(message)
      begin_job(uid)
    else
      set_job_status(uid, JobStatus::Failed)
    end

  end
end

# check if its time to DIE
resp = @client.query("SELECT * FROM jobs WHERE status=#{JobStatus::CompletedWork}")
puts "Check MYSQL at end"
puts resp.inspect


# CREATE TABLE jobs (uid varchar(255), status int, input_filepath varchar(1024));