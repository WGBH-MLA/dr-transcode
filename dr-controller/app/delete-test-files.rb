
require 'aws-sdk-sqs'
require 'mysql2'
puts "deleting mysql"
@client = Mysql2::Client.new(host: "mysql", username: "root", database: "drtranscode", password: "", port: 3306)
@client.query('delete from jobs')


puts "deleting sqs"
@sqs = Aws::SQS::Client.new(
  region: 'us-east-1',
  # reading these in from files because ENV variables are not available in cronjob, and getting them piped into cron login sessions is apparently impossible with however they are injected into the container in rancher 
  access_key_id: File.read('/root/sqs/sqs_a'),
  secret_access_key: File.read('/root/sqs/sqs_s')
)
msgs = @sqs.receive_message(queue_url: 'https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue', max_number_of_messages: 10).messages
msgs.each do |message|
  puts "Deleting message #{message.receipt_handle}"
  @sqs.delete_message({queue_url: 'https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue', receipt_handle: message.receipt_handle})
end

puts "deleting test output" 
`aws --endpoint-url 'http://s3-bos.wgbh.org' s3api delete-object --bucket nehdigitization --key pip_input.mp4`
`aws --endpoint-url 'http://s3-bos.wgbh.org' s3api delete-object --bucket nehdigitization --key earthly_input.mp4`
`aws --endpoint-url 'http://s3-bos.wgbh.org' s3api delete-object --bucket nehdigitization --key giant_seq_input.mp4`
