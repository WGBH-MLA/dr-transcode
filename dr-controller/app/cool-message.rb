require 'aws-sdk-sqs'
puts "Dohh!"
sqs = Aws::SQS::Client.new(
  region: 'us-east-1',
  access_key_id: ENV['SQS_ACCESS_KEY_ID'],
  secret_access_key: ENV['SQS_SECRET_ACCESS_KEY']
)

puts "Woo-hoo!"
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "23796/barcode146543/PreservationMaster/barcode146543.mkv"}) })

sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "23796/barcode175244/PreservationMaster/barcode175244.mkv"}) })


puts "Wa-hahhh!!!"