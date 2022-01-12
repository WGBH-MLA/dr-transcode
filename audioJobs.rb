puts "Dohh!"

def send_message(queue_url, key)
  puts "Adding message #{key} to #{queue_url}"
  `aws --region region1 --endpoint-url 'http://s3-sqs.wgbh.org:18090/' sqs send-message --queue-url #{queue_url} --message-body #{key}`
end

# little weird
queue_url = File.read('/root/queueurl/DRTRANSCODE_QUEUE_URL')

puts "Woo-hoo!"

keys = [
  # replicate the s3 notification msg format
  # %({ "Records": [ { "s3": { "object": { "key": "KEY GOES HERE WOW" } } } ] })

  # left TC (preserve channel 2)
  # %('{ "jobType": 2, "Records": [ { "s3": { "object": { "key": "23406/barcode163690/PreservationMaster/barcode163690.mp4" } } } ] }'),
  # right TC (preserve channel 1)
  # %('{ "jobType": 1, "Records": [ { "s3": { "bucket": { "name": "nehdigitization" }, "object": { "key": "23625/barcode127471/PreservationMaster/barcode127471.mp4" } } } ] }'),


# %('{ "jobType": 1, "Records": [ { "s3": { "bucket": { "name": "nehdigitization" }, "bucket": { "name": "nehdigitization" }, "object": { "key": "23889/barcode134969/PreservationMaster/barcode134969.mp4" } } } ] }'),

]

keys.each do |key|
  send_message(queue_url, key)
end

puts "Wa-hahhh!!!"

puts "Metal... Gear!"
