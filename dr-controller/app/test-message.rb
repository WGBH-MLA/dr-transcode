require 'aws-sdk-sqs'
puts "Dohh!"
sqs = Aws::SQS::Client.new(
  region: 'us-east-1',
  access_key_id: ENV['SQS_ACCESS_KEY_ID'],
  secret_access_key: ENV['SQS_SECRET_ACCESS_KEY']
)

puts "Woo-hoo!"

# needs rerun
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "23797/barcode142151/PreservationMaster/barcode142151.mov"}) })

# should fail
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "23797/barcode241112/PreservationMaster/barcode241112.mov"}) })

#should success
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "23797/barcode241103/PreservationMaster/barcode241103.mov"}) })

# sqs.send_message({
#     queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", 
#     message_body: %({"input_filepath": "pip_input.mkv"})
#   })
# sqs.send_message({
#     queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", 
#     message_body: %({"input_filepath": "earthly_input.mkv"})
#   })
# sqs.send_message({
#     queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", 
#     message_body: %({"input_filepath": "giant_seq_input.mkv"})
#   })

puts "Wa-hahhh!!!"