require 'mysql2'
require 'aws-sdk-sqs'
require 'securerandom'
require 'json'

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
  # check that file exists
  # check that file not too big
  true
end

def init_job(input_filename)
  # chck if job already started..
  # return if already found
  uid = SecureRandom.uuid
  query = %(INSERT INTO jobs (uid, status, input_filename) VALUES("#{uid}", #{JobStatus::Received}, "#{input_filename}"))
  puts query
  resp = @client.query(query)
  return uid
end

def begin_job(uid)
  # start the ffmpeg job
  # run kubectl command..

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
    input_filename = JSON.parse(message.body)[:input_filename]
    uid = init_job(input_filename)

    if validate_sqs_message(message)
      begin_job(input_filename)
    else
      set_job_status(uid, JobStatus::Failed)
    end

  end
end

# check if its time to DIE
resp = @client.query("select * from jobs where status=#{JobStatus::CompletedWork}")
puts resp.inspect


# CREATE TABLE jobs (uid varchar(255), status int, input_filename varchar(1024));