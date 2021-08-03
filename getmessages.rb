require 'json'

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




# ================================================================================

File.open("sqs-message-keys.txt", "w+") do |f|
  msgs = receive_sqs_messages("http://s3-sqs.wgbh.org/21ef364f2697e48b99dfeab6851afb19/dr-transcode-sqs-queue")
  msgs.each do |msg|
    puts "Writing..."
    f << %(#{job_info_from_sqs_message(msg).to_s}\n)
  
    puts "try to delete! #{msgs.first["MessageId"]}"
    delete_sqs_message("http://s3-sqs.wgbh.org/21ef364f2697e48b99dfeab6851afb19/dr-transcode-sqs-queue", msgs.first["ReceiptHandle"] )
  end

end
