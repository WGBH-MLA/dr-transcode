puts "Dohh!"

def send_message(queue_url, key)
  puts "Adding message #{key} to #{queue_url}"
  `aws --region region1 --endpoint-url 'http://s3-sqs.wgbh.org:18090/' sqs send-message --queue-url #{queue_url} --message-body #{key}`
end

queue_url = File.read('/root/queueurl/DRTRANSCODE_QUEUE_URL')

puts "Woo-hoo!"

  # %('{ "manualAction": "stripTimecode", "manualParameter": "stripLeft", "Records": [ { "s3": { "object": { "key": "24324/barcode142167/PreservationMaster/barcode142167.mkv" } } } ] }'),



keys = [
  # replicate the s3 notification msg format
  # %('{ "Records": [ { "s3": { "bucket": { "name": "nehdigitization" }, "object": { "key": "24534/barcode63023/PreservationMaster/barcode63023.mkv" } } } ] }'),
  # %('{ "Records": [ { "s3": { "bucket": { "name": "asiacollection" }, "object": { "key": "asiacol/barcode104521/PreservationMaster/barcode104521.mkv" } } } ] }'),
  # %('{ "Records": [ { "s3": { "bucket": { "name": "nehdigitization" }, "object": { "key": "23406/barcode163691/PreservationMaster/barcode163691.mkv" } } } ] }'),

  %('{ "jobType": 1, "Records": [ { "s3": { "bucket": { "name": "streaming-proxies" }, "object": { "key": "nehdigitization/23406/barcode163691/PreservationMaster/barcode163691.mp4" } } } ] }'),


]

keys.each do |key|
  send_message(queue_url, key)
end

# # november batch
# sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "24153/barcode144878/PreservationMaster/barcode144878.mkv"}) })
puts "Wa-hahhh!!!"
