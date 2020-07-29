require 'mysql2'
require 'aws-sdk-sqs'
require 'securerandom'

module JobStatus
  Received = 0
  Working = 1
  CompletedWork = 2
  Retired = 3
  Failed = 4
end

def set_job_status(uid, new_status)
  puts "Setting job status for #{uid} to #{new_status}"
  puts client.query("UPDATE jobs SET status=#{new_status} WHERE uid=#{uid}")
end

def validate_sqs_message(msg)
  # check not already received
  # check that file exists
  # check that file not too big
  true
end

def init_job(msg)
  # set up job in mysql db

  # unique job id
  uid = SecureRandom.uuid
  status = JobStatus::Received
  input_filename = "nothin"

  resp = client.query(%(INSERT INTO jobs (uid, status, input_filename) VALUES(#{uid}, #{status}, #{input_filename})))
  puts resp.inspect
end

def begin_job(uid, input_filename)
  # start the ffmpeg job
  
  # run kubectl command..
  puts "I sure would like to start #{uid} for #{input_filename}!"
  set_job_status(uid, JobStatus::Working)
end

# load db..
client = Mysql2::Client.new(host: "mysql", username: "root", database: "drtranscode", password: "", port: 3306)
sqs = Aws::SQS::Client.new(region: 'us-east-1')
resp = sqs.receive_message(queue_url: 'https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue.fifo', max_number_of_messages: 10)

# check if its time to LIVE
msgs = resp.messages
if msgs.present?
  msgs.each do |message|

    puts message.inspect

    if validate_sqs_message(message)

      init_job(message)
      input_filename = message[:input_filename]
      begin_job(uid, input_filename)

    else
      set_job_status(uid, JobStatus::Failed)
    end

  end
end

# check if its time to DIE
resp = client.query("select * from jobs where status=#{JobStatus::CompletedWork}")
puts resp


# CREATE TABLE jobs (uid varchar(255), status int, input_filename varchar(1024));