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

  # left TC (preserve channel 2)
  # %('{ "jobType": 2, "Records": [ { "s3": { "object": { "key": "23406/barcode163690/PreservationMaster/barcode163690.mp4" } } } ] }'),
  # right TC (preserve channel 1)
  # %('{ "jobType": 1, "Records": [ { "s3": { "object": { "key": "23625/barcode127471/PreservationMaster/barcode127471.mp4" } } } ] }'),

  %('{ "jobType": 2, "Records": [ { "s3": { "object": { "key": "23406/barcode163690/PreservationMaster/barcode163690.mp4" } } } ] }'),
  %('{ "jobType": 2, "Records": [ { "s3": { "object": { "key": "23406/barcode163689/PreservationMaster/barcode163689.mp4" } } } ] }'),
  %('{ "jobType": 2, "Records": [ { "s3": { "object": { "key": "23406/barcode163903/PreservationMaster/barcode163903.mp4" } } } ] }'),
  %('{ "jobType": 2, "Records": [ { "s3": { "object": { "key": "23406/barcode163905/PreservationMaster/barcode163905.mp4" } } } ] }'),
  %('{ "jobType": 2, "Records": [ { "s3": { "object": { "key": "23406/barcode163901/PreservationMaster/barcode163901.mp4" } } } ] }'),
  %('{ "jobType": 2, "Records": [ { "s3": { "object": { "key": "23406/barcode163904/PreservationMaster/barcode163904.mp4" } } } ] }'),
  %('{ "jobType": 2, "Records": [ { "s3": { "object": { "key": "23406/barcode163900/PreservationMaster/barcode163900.mp4" } } } ] }'),
  %('{ "jobType": 2, "Records": [ { "s3": { "object": { "key": "23406/barcode163902/PreservationMaster/barcode163902.mp4" } } } ] }'),
  %('{ "jobType": 2, "Records": [ { "s3": { "object": { "key": "24119/barcode103894/PreservationMaster/barcode103894.mp4" } } } ] }'),

  %('{ "jobType": 1, "Records": [ { "s3": { "object": { "key": "23625/barcode127471/PreservationMaster/barcode127471.mp4" } } } ] }'),
  %('{ "jobType": 1, "Records": [ { "s3": { "object": { "key": "23796/barcode249487/PreservationMaster/barcode249487.mp4" } } } ] }'),
  %('{ "jobType": 1, "Records": [ { "s3": { "object": { "key": "23625/barcode249968/PreservationMaster/barcode249968.mp4" } } } ] }'),
  %('{ "jobType": 1, "Records": [ { "s3": { "object": { "key": "23889/barcode18483/PreservationMaster/barcode18483.mp4" } } } ] }'),
  %('{ "jobType": 1, "Records": [ { "s3": { "object": { "key": "24146/barcode77032/PreservationMaster/barcode77032.mp4" } } } ] }'),
  %('{ "jobType": 1, "Records": [ { "s3": { "object": { "key": "23796/barcode250442/PreservationMaster/barcode250442.mp4" } } } ] }'),
  %('{ "jobType": 1, "Records": [ { "s3": { "object": { "key": "23796/barcode250445/PreservationMaster/barcode250445.mp4" } } } ] }'),
  %('{ "jobType": 1, "Records": [ { "s3": { "object": { "key": "23033/barcode194120/PreservationMaster/barcode194120.mp4" } } } ] }'),
  %('{ "jobType": 1, "Records": [ { "s3": { "object": { "key": "23033/barcode194122/PreservationMaster/barcode194122.mp4" } } } ] }'),
  %('{ "jobType": 1, "Records": [ { "s3": { "object": { "key": "23033/barcode194139/PreservationMaster/barcode194139.mp4" } } } ] }'),
  %('{ "jobType": 1, "Records": [ { "s3": { "object": { "key": "23625/barcode246805/PreservationMaster/barcode246805.mp4" } } } ] }'),
  %('{ "jobType": 1, "Records": [ { "s3": { "object": { "key": "23745/barcode246785/PreservationMaster/barcode246785.mp4" } } } ] }'),
  %('{ "jobType": 1, "Records": [ { "s3": { "object": { "key": "23625/barcode191170/PreservationMaster/barcode191170.mp4" } } } ] }'),
  %('{ "jobType": 1, "Records": [ { "s3": { "object": { "key": "23625/barcode192387/PreservationMaster/barcode192387.mp4" } } } ] }'),
  %('{ "jobType": 1, "Records": [ { "s3": { "object": { "key": "23625/barcode192351/PreservationMaster/barcode192351.mp4" } } } ] }'),
  %('{ "jobType": 1, "Records": [ { "s3": { "object": { "key": "23928/barcode382880/PreservationMaster/barcode382880.mp4" } } } ] }'),
  %('{ "jobType": 1, "Records": [ { "s3": { "object": { "key": "23928/barcode382891/PreservationMaster/barcode382891.mp4" } } } ] }'),
  %('{ "jobType": 1, "Records": [ { "s3": { "object": { "key": "23920/barcode382878/PreservationMaster/barcode382878.mp4" } } } ] }'),
  %('{ "jobType": 1, "Records": [ { "s3": { "object": { "key": "23920/barcode382885/PreservationMaster/barcode382885.mp4" } } } ] }'),
  %('{ "jobType": 1, "Records": [ { "s3": { "object": { "key": "23968/barcode19003/PreservationMaster/barcode19003.mp4" } } } ] }'),
  %('{ "jobType": 1, "Records": [ { "s3": { "object": { "key": "23968/barcode67870/PreservationMaster/barcode67870.mp4" } } } ] }'),
  %('{ "jobType": 1, "Records": [ { "s3": { "object": { "key": "23928/barcode20781/PreservationMaster/barcode20781.mp4" } } } ] }'),
  %('{ "jobType": 1, "Records": [ { "s3": { "object": { "key": "23928/barcode20780/PreservationMaster/barcode20780.mp4" } } } ] }'),
  %('{ "jobType": 1, "Records": [ { "s3": { "object": { "key": "23889/barcode134969/PreservationMaster/barcode134969.mp4" } } } ] }'),
  %('{ "jobType": 1, "Records": [ { "s3": { "object": { "key": "23889/barcode134970/PreservationMaster/barcode134970.mp4" } } } ] }'),
  %('{ "jobType": 1, "Records": [ { "s3": { "object": { "key": "23968/barcode41026/PreservationMaster/barcode41026.mp4" } } } ] }'),
  %('{ "jobType": 1, "Records": [ { "s3": { "object": { "key": "23968/barcode106523/PreservationMaster/barcode106523.mp4" } } } ] }'),
  %('{ "jobType": 1, "Records": [ { "s3": { "object": { "key": "24038/barcode193921/PreservationMaster/barcode193921.mp4" } } } ] }'),
  %('{ "jobType": 1, "Records": [ { "s3": { "object": { "key": "24119/barcode192936/PreservationMaster/barcode192936.mp4" } } } ] }'),
  %('{ "jobType": 1, "Records": [ { "s3": { "object": { "key": "24119/barcode192966/PreservationMaster/barcode192966.mp4" } } } ] }'),
  %('{ "jobType": 1, "Records": [ { "s3": { "object": { "key": "24119/barcode192965/PreservationMaster/barcode192965.mp4" } } } ] }'),
  %('{ "jobType": 1, "Records": [ { "s3": { "object": { "key": "24119/barcode192967/PreservationMaster/barcode192967.mp4" } } } ] }'),
  %('{ "jobType": 1, "Records": [ { "s3": { "object": { "key": "24119/barcode192970/PreservationMaster/barcode192970.mp4" } } } ] }'),
  %('{ "jobType": 1, "Records": [ { "s3": { "object": { "key": "24119/barcode192969/PreservationMaster/barcode192969.mp4" } } } ] }'),
  %('{ "jobType": 1, "Records": [ { "s3": { "object": { "key": "24146/barcode106521/PreservationMaster/barcode106521.mp4" } } } ] }'),
  %('{ "jobType": 1, "Records": [ { "s3": { "object": { "key": "24336/barcode193001/PreservationMaster/barcode193001.mp4" } } } ] }'),
  %('{ "jobType": 1, "Records": [ { "s3": { "object": { "key": "24336/barcode193000/PreservationMaster/barcode193000.mp4" } } } ] }'),
  %('{ "jobType": 1, "Records": [ { "s3": { "object": { "key": "24336/barcode192999/PreservationMaster/barcode192999.mp4" } } } ] }'),
]

keys.each do |key|
  send_message(queue_url, key)
end


puts "Wa-hahhh!!!"

puts "Metal... Gear!"