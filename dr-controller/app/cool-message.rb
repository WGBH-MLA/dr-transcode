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
  %('{ "Records": [ { "s3": { "bucket": { "name": "asiacollection" }, "object": { "key": "asiacol/barcode106039/PreservationMaster/barcode106039_1.mkv" } } } ] }'),
  %('{ "Records": [ { "s3": { "bucket": { "name": "asiacollection" }, "object": { "key": "asiacol/barcode106039/PreservationMaster/barcode106039_2.mkv" } } } ] }'),
  %('{ "Records": [ { "s3": { "bucket": { "name": "asiacollection" }, "object": { "key": "asiacol/barcode106039/PreservationMaster/barcode106039_3.mkv" } } } ] }'),
  %('{ "Records": [ { "s3": { "bucket": { "name": "asiacollection" }, "object": { "key": "asiacol/barcode167514/PreservationMaster/barcode167514.mkv" } } } ] }'),
  %('{ "Records": [ { "s3": { "bucket": { "name": "asiacollection" }, "object": { "key": "asiacol/barcode279613/PreservationMaster/barcode279613.mkv" } } } ] }'),
  %('{ "Records": [ { "s3": { "bucket": { "name": "asiacollection" }, "object": { "key": "asiacol/barcode343792/PreservationMaster/barcode343792.dv" } } } ] }'),
  %('{ "Records": [ { "s3": { "bucket": { "name": "asiacollection" }, "object": { "key": "asiacol/barcode384458/PreservationMaster/barcode384458_01.wav" } } } ] }'),
  %('{ "Records": [ { "s3": { "bucket": { "name": "nehdigitization" }, "object": { "key": "24153/barcode258425/PreservationMaster/barcode258425.mkv" } } } ] }'),

  

]

keys.each do |key|
  send_message(queue_url, key)
end

# # november batch
# sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "24153/barcode144878/PreservationMaster/barcode144878.mkv"}) })
puts "Wa-hahhh!!!"
