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
  # %({ "Records": [ { "s3": { "object": { "key": "KEY GOES HERE WOW" } } } ] })
  %('{ "Records": [ { "s3": { "object": { "key": "24082/barcode143980/PreservationMaster/barcode143980.mkv" } } } ] }'),
  %('{ "Records": [ { "s3": { "object": { "key": "24153/barcode26701/PreservationMaster/barcode26701.mkv" } } } ] }'),
  %('{ "Records": [ { "s3": { "object": { "key": "24082/barcode146001/PreservationMaster/barcode146001.mkv" } } } ] }'),
  %('{ "Records": [ { "s3": { "object": { "key": "24082/barcode146031/PreservationMaster/barcode146031.mkv" } } } ] }'),
  %('{ "Records": [ { "s3": { "object": { "key": "24082/barcode146032/PreservationMaster/barcode146032.mkv" } } } ] }'),
  %('{ "Records": [ { "s3": { "object": { "key": "24082/barcode146556/PreservationMaster/barcode146556.mkv" } } } ] }'),
  %('{ "Records": [ { "s3": { "object": { "key": "24082/barcode146874/PreservationMaster/barcode146874.mkv" } } } ] }'),
  %('{ "Records": [ { "s3": { "object": { "key": "24082/barcode146877/PreservationMaster/barcode146877.mkv" } } } ] }'),
  %('{ "Records": [ { "s3": { "object": { "key": "24082/barcode146878/PreservationMaster/barcode146878.mkv" } } } ] }'),
  %('{ "Records": [ { "s3": { "object": { "key": "24082/barcode146888/PreservationMaster/barcode146888.mkv" } } } ] }'),
  %('{ "Records": [ { "s3": { "object": { "key": "23920/barcode258194/PreservationMaster/barcode258194.mkv" } } } ] }'),
  %('{ "Records": [ { "s3": { "object": { "key": "24119/barcode23823/PreservationMaster/barcode23823.mkv" } } } ] }'),
  %('{ "Records": [ { "s3": { "object": { "key": "24153/barcode238430/PreservationMaster/barcode238430.mkv" } } } ] }'),
  %('{ "Records": [ { "s3": { "object": { "key": "23920/barcode181383/PreservationMaster/barcode181383.mkv" } } } ] }'),
  %('{ "Records": [ { "s3": { "object": { "key": "23920/barcode181382/PreservationMaster/barcode181382.mkv" } } } ] }'),
  %('{ "Records": [ { "s3": { "object": { "key": "23920/barcode181483/PreservationMaster/barcode181483.mkv" } } } ] }'),
  %('{ "Records": [ { "s3": { "object": { "key": "23920/barcode181482/PreservationMaster/barcode181482.mkv" } } } ] }'),
  %('{ "Records": [ { "s3": { "object": { "key": "23920/barcode181478/PreservationMaster/barcode181478.mkv" } } } ] }'),
  %('{ "Records": [ { "s3": { "object": { "key": "23920/barcode20342/PreservationMaster/barcode20342.mkv" } } } ] }'),
  %('{ "Records": [ { "s3": { "object": { "key": "23920/barcode258167/PreservationMaster/barcode258167.mkv" } } } ] }'),
  %('{ "Records": [ { "s3": { "object": { "key": "24153/barcode137176/PreservationMaster/barcode137176.mkv" } } } ] }'),
  %('{ "Records": [ { "s3": { "object": { "key": "24153/barcode137184/PreservationMaster/barcode137184.mkv" } } } ] }'),
  %('{ "Records": [ { "s3": { "object": { "key": "25661/barcode333101/PreservationMaster/barcode333101.mkv" } } } ] }'),
]

keys.each do |key|
  send_message(queue_url, key)
end

# # november batch
# sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "24153/barcode144878/PreservationMaster/barcode144878.mkv"}) })
puts "Wa-hahhh!!!"