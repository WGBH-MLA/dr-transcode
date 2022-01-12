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

  # %('{ "jobType": 2, "Records": [ { "s3": { "bucket": { "name": "streaming-proxies" }, "object": { "key": "nehdigitization/23406/barcode163691/PreservationMaster/barcode163691.mp4" } } } ] }'),
  # %('{ "jobType": 0, "Records": [ { "s3": { "bucket": { "name": "nehdigitization" }, "object": { "key": "23406/barcode163691/PreservationMaster/barcode163691.mkv" } } } ] }'),
%('{ "jobType": 0, "Records": [ { "s3": { "bucket": { "name": "nehdigitization" }, "object": { "key": "27331/barcode198360/PreservationMaster/barcode198360.mkv" } } } ] }'),
%('{ "jobType": 0, "Records": [ { "s3": { "bucket": { "name": "nehdigitization" }, "object": { "key": "27331/barcode198168/PreservationMaster/barcode198168.mkv" } } } ] }'),
%('{ "jobType": 0, "Records": [ { "s3": { "bucket": { "name": "nehdigitization" }, "object": { "key": "27331/barcode198170/PreservationMaster/barcode198170.mkv" } } } ] }'),
%('{ "jobType": 0, "Records": [ { "s3": { "bucket": { "name": "nehdigitization" }, "object": { "key": "27331/barcode198417/PreservationMaster/barcode198417.mkv" } } } ] }'),
%('{ "jobType": 0, "Records": [ { "s3": { "bucket": { "name": "nehdigitization" }, "object": { "key": "27331/barcode198418/PreservationMaster/barcode198418.mkv" } } } ] }'),
%('{ "jobType": 0, "Records": [ { "s3": { "bucket": { "name": "nehdigitization" }, "object": { "key": "27331/barcode198394/PreservationMaster/barcode198394.mkv" } } } ] }'),
%('{ "jobType": 0, "Records": [ { "s3": { "bucket": { "name": "nehdigitization" }, "object": { "key": "27331/barcode198396/PreservationMaster/barcode198396.mkv" } } } ] }'),
%('{ "jobType": 0, "Records": [ { "s3": { "bucket": { "name": "nehdigitization" }, "object": { "key": "27331/barcode198397/PreservationMaster/barcode198397.mkv" } } } ] }'),
%('{ "jobType": 0, "Records": [ { "s3": { "bucket": { "name": "nehdigitization" }, "object": { "key": "27331/barcode198372/PreservationMaster/barcode198372.mkv" } } } ] }'),
%('{ "jobType": 0, "Records": [ { "s3": { "bucket": { "name": "nehdigitization" }, "object": { "key": "27331/barcode198376/PreservationMaster/barcode198376.mkv" } } } ] }'),
%('{ "jobType": 0, "Records": [ { "s3": { "bucket": { "name": "nehdigitization" }, "object": { "key": "27331/barcode198378/PreservationMaster/barcode198378.mkv" } } } ] }'),
%('{ "jobType": 0, "Records": [ { "s3": { "bucket": { "name": "nehdigitization" }, "object": { "key": "27331/barcode198381/PreservationMaster/barcode198381.mkv" } } } ] }'),
%('{ "jobType": 0, "Records": [ { "s3": { "bucket": { "name": "nehdigitization" }, "object": { "key": "27331/barcode198387/PreservationMaster/barcode198387.mkv" } } } ] }'),
%('{ "jobType": 0, "Records": [ { "s3": { "bucket": { "name": "nehdigitization" }, "object": { "key": "27331/barcode198388/PreservationMaster/barcode198388.mkv" } } } ] }'),
%('{ "jobType": 0, "Records": [ { "s3": { "bucket": { "name": "nehdigitization" }, "object": { "key": "27331/barcode195708/PreservationMaster/barcode195708.mkv" } } } ] }'),
%('{ "jobType": 0, "Records": [ { "s3": { "bucket": { "name": "nehdigitization" }, "object": { "key": "27331/barcode198335/PreservationMaster/barcode198335.mkv" } } } ] }'),
%('{ "jobType": 0, "Records": [ { "s3": { "bucket": { "name": "nehdigitization" }, "object": { "key": "27331/barcode198420/PreservationMaster/barcode198420.mkv" } } } ] }'),
%('{ "jobType": 0, "Records": [ { "s3": { "bucket": { "name": "nehdigitization" }, "object": { "key": "27331/barcode198422/PreservationMaster/barcode198422.mkv" } } } ] }'),
%('{ "jobType": 0, "Records": [ { "s3": { "bucket": { "name": "nehdigitization" }, "object": { "key": "27331/barcode198365/PreservationMaster/barcode198365.mkv" } } } ] }'),
%('{ "jobType": 0, "Records": [ { "s3": { "bucket": { "name": "nehdigitization" }, "object": { "key": "27331/barcode198364/PreservationMaster/barcode198364.mkv" } } } ] }'),
%('{ "jobType": 0, "Records": [ { "s3": { "bucket": { "name": "nehdigitization" }, "object": { "key": "27331/barcode198359/PreservationMaster/barcode198359.mkv" } } } ] }'),
%('{ "jobType": 0, "Records": [ { "s3": { "bucket": { "name": "nehdigitization" }, "object": { "key": "27331/barcode198358/PreservationMaster/barcode198358.mkv" } } } ] }'),
%('{ "jobType": 0, "Records": [ { "s3": { "bucket": { "name": "nehdigitization" }, "object": { "key": "27331/barcode198499/PreservationMaster/barcode198499.mkv" } } } ] }'),
%('{ "jobType": 0, "Records": [ { "s3": { "bucket": { "name": "nehdigitization" }, "object": { "key": "27331/barcode198498/PreservationMaster/barcode198498.mkv" } } } ] }'),
%('{ "jobType": 0, "Records": [ { "s3": { "bucket": { "name": "nehdigitization" }, "object": { "key": "27331/barcode198497/PreservationMaster/barcode198497.mkv" } } } ] }'),
%('{ "jobType": 0, "Records": [ { "s3": { "bucket": { "name": "nehdigitization" }, "object": { "key": "27331/barcode198496/PreservationMaster/barcode198496.mkv" } } } ] }'),
%('{ "jobType": 0, "Records": [ { "s3": { "bucket": { "name": "nehdigitization" }, "object": { "key": "27331/barcode198494/PreservationMaster/barcode198494.mkv" } } } ] }'),
%('{ "jobType": 0, "Records": [ { "s3": { "bucket": { "name": "nehdigitization" }, "object": { "key": "27331/barcode198493/PreservationMaster/barcode198493.mkv" } } } ] }'),
%('{ "jobType": 0, "Records": [ { "s3": { "bucket": { "name": "nehdigitization" }, "object": { "key": "27331/barcode198169/PreservationMaster/barcode198169.mkv" } } } ] }'),
%('{ "jobType": 0, "Records": [ { "s3": { "bucket": { "name": "nehdigitization" }, "object": { "key": "27331/barcode198419/PreservationMaster/barcode198419.mkv" } } } ] }'),
%('{ "jobType": 0, "Records": [ { "s3": { "bucket": { "name": "nehdigitization" }, "object": { "key": "27331/barcode198395/PreservationMaster/barcode198395.mkv" } } } ] }'),
%('{ "jobType": 0, "Records": [ { "s3": { "bucket": { "name": "nehdigitization" }, "object": { "key": "27331/barcode198382/PreservationMaster/barcode198382.mkv" } } } ] }'),
%('{ "jobType": 0, "Records": [ { "s3": { "bucket": { "name": "nehdigitization" }, "object": { "key": "27331/barcode198383/PreservationMaster/barcode198383.mkv" } } } ] }'),
%('{ "jobType": 0, "Records": [ { "s3": { "bucket": { "name": "nehdigitization" }, "object": { "key": "27331/barcode198377/PreservationMaster/barcode198377.mkv" } } } ] }'),
%('{ "jobType": 0, "Records": [ { "s3": { "bucket": { "name": "nehdigitization" }, "object": { "key": "27331/barcode195709/PreservationMaster/barcode195709.mkv" } } } ] }'),
%('{ "jobType": 0, "Records": [ { "s3": { "bucket": { "name": "nehdigitization" }, "object": { "key": "27331/barcode198336/PreservationMaster/barcode198336.mkv" } } } ] }'),
%('{ "jobType": 0, "Records": [ { "s3": { "bucket": { "name": "nehdigitization" }, "object": { "key": "27331/barcode198351/PreservationMaster/barcode198351.mkv" } } } ] }'),
%('{ "jobType": 0, "Records": [ { "s3": { "bucket": { "name": "nehdigitization" }, "object": { "key": "27331/barcode198349/PreservationMaster/barcode198349.mkv" } } } ] }'),
%('{ "jobType": 0, "Records": [ { "s3": { "bucket": { "name": "nehdigitization" }, "object": { "key": "27331/barcode198421/PreservationMaster/barcode198421.mkv" } } } ] }'),
%('{ "jobType": 0, "Records": [ { "s3": { "bucket": { "name": "nehdigitization" }, "object": { "key": "27331/barcode198367/PreservationMaster/barcode198367.mkv" } } } ] }'),
%('{ "jobType": 0, "Records": [ { "s3": { "bucket": { "name": "nehdigitization" }, "object": { "key": "27331/barcode198366/PreservationMaster/barcode198366.mkv" } } } ] }'),
%('{ "jobType": 0, "Records": [ { "s3": { "bucket": { "name": "nehdigitization" }, "object": { "key": "27331/barcode198363/PreservationMaster/barcode198363.mkv" } } } ] }'),
%('{ "jobType": 0, "Records": [ { "s3": { "bucket": { "name": "nehdigitization" }, "object": { "key": "27331/barcode198362/PreservationMaster/barcode198362.mkv" } } } ] }'),
%('{ "jobType": 0, "Records": [ { "s3": { "bucket": { "name": "nehdigitization" }, "object": { "key": "27331/barcode198361/PreservationMaster/barcode198361.mkv" } } } ] }'),
%('{ "jobType": 0, "Records": [ { "s3": { "bucket": { "name": "nehdigitization" }, "object": { "key": "27331/barcode198344/PreservationMaster/barcode198344.mkv" } } } ] }'),
%('{ "jobType": 0, "Records": [ { "s3": { "bucket": { "name": "nehdigitization" }, "object": { "key": "27331/barcode198356/PreservationMaster/barcode198356.mkv" } } } ] }'),
%('{ "jobType": 0, "Records": [ { "s3": { "bucket": { "name": "nehdigitization" }, "object": { "key": "27331/barcode198354/PreservationMaster/barcode198354.mkv" } } } ] }'),
%('{ "jobType": 0, "Records": [ { "s3": { "bucket": { "name": "nehdigitization" }, "object": { "key": "27331/barcode198353/PreservationMaster/barcode198353.mkv" } } } ] }'),
%('{ "jobType": 0, "Records": [ { "s3": { "bucket": { "name": "nehdigitization" }, "object": { "key": "27331/barcode198167/PreservationMaster/barcode198167.mkv" } } } ] }'),
%('{ "jobType": 0, "Records": [ { "s3": { "bucket": { "name": "nehdigitization" }, "object": { "key": "27331/barcode198374/PreservationMaster/barcode198374.mkv" } } } ] }'),
%('{ "jobType": 0, "Records": [ { "s3": { "bucket": { "name": "nehdigitization" }, "object": { "key": "27331/barcode198375/PreservationMaster/barcode198375.mkv" } } } ] }'),
%('{ "jobType": 0, "Records": [ { "s3": { "bucket": { "name": "nehdigitization" }, "object": { "key": "27331/barcode198425/PreservationMaster/barcode198425.mkv" } } } ] }'),
%('{ "jobType": 0, "Records": [ { "s3": { "bucket": { "name": "nehdigitization" }, "object": { "key": "27331/barcode198433/PreservationMaster/barcode198433.mkv" } } } ] }'),
%('{ "jobType": 0, "Records": [ { "s3": { "bucket": { "name": "nehdigitization" }, "object": { "key": "27331/barcode198402/PreservationMaster/barcode198402.mkv" } } } ] }'),
%('{ "jobType": 0, "Records": [ { "s3": { "bucket": { "name": "nehdigitization" }, "object": { "key": "27331/barcode198401/PreservationMaster/barcode198401.mkv" } } } ] }'),
%('{ "jobType": 0, "Records": [ { "s3": { "bucket": { "name": "nehdigitization" }, "object": { "key": "27331/barcode198492/PreservationMaster/barcode198492.mkv" } } } ] }'),
%('{ "jobType": 0, "Records": [ { "s3": { "bucket": { "name": "nehdigitization" }, "object": { "key": "27331/barcode198491/PreservationMaster/barcode198491.mkv" } } } ] }'),
%('{ "jobType": 0, "Records": [ { "s3": { "bucket": { "name": "nehdigitization" }, "object": { "key": "27331/barcode198352/PreservationMaster/barcode198352.mkv" } } } ] }'),
%('{ "jobType": 0, "Records": [ { "s3": { "bucket": { "name": "nehdigitization" }, "object": { "key": "27331/barcode198373/PreservationMaster/barcode198373.mkv" } } } ] }'),
%('{ "jobType": 0, "Records": [ { "s3": { "bucket": { "name": "nehdigitization" }, "object": { "key": "27331/barcode198432/PreservationMaster/barcode198432.mkv" } } } ] }'),
%('{ "jobType": 0, "Records": [ { "s3": { "bucket": { "name": "nehdigitization" }, "object": { "key": "27331/barcode25193/PreservationMaster/barcode25193.mkv" } } } ] }'),


]

keys.each do |key|
  send_message(queue_url, key)
end

# # november batch
# sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "24153/barcode144878/PreservationMaster/barcode144878.mkv"}) })
puts "Wa-hahhh!!!"
