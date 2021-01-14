puts "Dohh!"

def send_message(queue_url, key)
  puts "Adding message #{key} to #{queue_url}"
  `aws --region region1 --endpoint-url 'http://s3-sqs.wgbh.org:18090/' sqs send-message --queue-url #{queue_url} --message-body #{key}`
end

queue_url = File.read('/root/queueurl/DRTRANSCODE_QUEUE_URL')

puts "Woo-hoo!"

keys = [
  # replicate the s3 notification msg format
  # %({ "Records": [ { "s3": { "object": { "key": "KEY GOES HERE WOW" } } } ] })
  %('{ "Records": [ { "s3": { "object": { "key": "24153/barcode144878/PreservationMaster/barcode144878.mkv" } } } ] }')
]

keys.each do |key|
  send_message(queue_url, key)
end

# # november batch
# sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "24153/barcode144878/PreservationMaster/barcode144878.mkv"}) })
puts "Wa-hahhh!!!"