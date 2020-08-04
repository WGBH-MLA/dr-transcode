require 'aws-sdk-sqs'
puts "Dohh!"
sqs = Aws::SQS::Client.new(region: 'us-east-1')

puts "Woo-hoo!"
sqs.send_message({
    queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", 
    message_body: %({"input_filepath": "pip_input.mkv"})
  })

puts "Wa-hahhh!!!"