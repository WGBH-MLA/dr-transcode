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


# %('{ "jobType": 0, "Records": [ { "s3": { "bucket": { "name": "nehdigitization" }, "object": { "key": "24153/barcode65217/PreservationMaster/barcode65217.mkv" } } } ] }'),
# %('{ "jobType": 0, "Records": [ { "s3": { "bucket": { "name": "nehdigitization" }, "object": { "key": "24153/barcode65218/PreservationMaster/barcode65218.mkv" } } } ] }'),
# %('{ "jobType": 0, "Records": [ { "s3": { "bucket": { "name": "nehdigitization" }, "object": { "key": "24153/barcode100113/PreservationMaster/barcode100113.mkv" } } } ] }'),
# %('{ "jobType": 0, "Records": [ { "s3": { "bucket": { "name": "nehdigitization" }, "object": { "key": "24153/barcode107198/PreservationMaster/barcode107198.mkv" } } } ] }'),
# %('{ "jobType": 0, "Records": [ { "s3": { "bucket": { "name": "nehdigitization" }, "object": { "key": "24153/barcode137153/PreservationMaster/barcode137153.mkv" } } } ] }'),
# %('{ "jobType": 0, "Records": [ { "s3": { "bucket": { "name": "nehdigitization" }, "object": { "key": "24153/barcode137158/PreservationMaster/barcode137158.mkv" } } } ] }'),
# %('{ "jobType": 0, "Records": [ { "s3": { "bucket": { "name": "nehdigitization" }, "object": { "key": "24153/barcode137168/PreservationMaster/barcode137168.mkv" } } } ] }'),
# %('{ "jobType": 0, "Records": [ { "s3": { "bucket": { "name": "nehdigitization" }, "object": { "key": "24153/barcode137169/PreservationMaster/barcode137169.mkv" } } } ] }'),
# %('{ "jobType": 0, "Records": [ { "s3": { "bucket": { "name": "nehdigitization" }, "object": { "key": "24153/barcode137170/PreservationMaster/barcode137170.mkv" } } } ] }'),
# %('{ "jobType": 0, "Records": [ { "s3": { "bucket": { "name": "nehdigitization" }, "object": { "key": "24153/barcode137171/PreservationMaster/barcode137171.mkv" } } } ] }'),
# %('{ "jobType": 0, "Records": [ { "s3": { "bucket": { "name": "nehdigitization" }, "object": { "key": "24153/barcode137174/PreservationMaster/barcode137174.mkv" } } } ] }'),
# %('{ "jobType": 0, "Records": [ { "s3": { "bucket": { "name": "nehdigitization" }, "object": { "key": "24153/barcode137175/PreservationMaster/barcode137175.mkv" } } } ] }'),
# %('{ "jobType": 0, "Records": [ { "s3": { "bucket": { "name": "nehdigitization" }, "object": { "key": "24153/barcode137178/PreservationMaster/barcode137178.mkv" } } } ] }'),
# %('{ "jobType": 0, "Records": [ { "s3": { "bucket": { "name": "nehdigitization" }, "object": { "key": "24153/barcode144252/PreservationMaster/barcode144252.mkv" } } } ] }'),
# %('{ "jobType": 0, "Records": [ { "s3": { "bucket": { "name": "nehdigitization" }, "object": { "key": "24153/barcode144527/PreservationMaster/barcode144527.mkv" } } } ] }'),
# %('{ "jobType": 0, "Records": [ { "s3": { "bucket": { "name": "nehdigitization" }, "object": { "key": "24153/barcode144530/PreservationMaster/barcode144530.mkv" } } } ] }'),
# %('{ "jobType": 0, "Records": [ { "s3": { "bucket": { "name": "nehdigitization" }, "object": { "key": "24153/barcode144872/PreservationMaster/barcode144872.mkv" } } } ] }'),
# %('{ "jobType": 0, "Records": [ { "s3": { "bucket": { "name": "nehdigitization" }, "object": { "key": "24153/barcode144873/PreservationMaster/barcode144873.mkv" } } } ] }'),
# %('{ "jobType": 0, "Records": [ { "s3": { "bucket": { "name": "nehdigitization" }, "object": { "key": "24153/barcode144875/PreservationMaster/barcode144875.mkv" } } } ] }'),
# %('{ "jobType": 0, "Records": [ { "s3": { "bucket": { "name": "nehdigitization" }, "object": { "key": "24153/barcode144876/PreservationMaster/barcode144876.mkv" } } } ] }'),
# %('{ "jobType": 0, "Records": [ { "s3": { "bucket": { "name": "nehdigitization" }, "object": { "key": "24153/barcode144877/PreservationMaster/barcode144877.mkv" } } } ] }'),
# %('{ "jobType": 0, "Records": [ { "s3": { "bucket": { "name": "nehdigitization" }, "object": { "key": "24153/barcode144878/PreservationMaster/barcode144878.mkv" } } } ] }'),
# %('{ "jobType": 0, "Records": [ { "s3": { "bucket": { "name": "nehdigitization" }, "object": { "key": "24153/barcode144879/PreservationMaster/barcode144879.mkv" } } } ] }'),
# %('{ "jobType": 0, "Records": [ { "s3": { "bucket": { "name": "nehdigitization" }, "object": { "key": "24153/barcode144887/PreservationMaster/barcode144887.mkv" } } } ] }'),
# %('{ "jobType": 0, "Records": [ { "s3": { "bucket": { "name": "nehdigitization" }, "object": { "key": "24153/barcode144890/PreservationMaster/barcode144890.mkv" } } } ] }'),
# %('{ "jobType": 0, "Records": [ { "s3": { "bucket": { "name": "nehdigitization" }, "object": { "key": "24153/barcode144891/PreservationMaster/barcode144891.mkv" } } } ] }'),
# %('{ "jobType": 0, "Records": [ { "s3": { "bucket": { "name": "nehdigitization" }, "object": { "key": "24153/barcode144893/PreservationMaster/barcode144893.mkv" } } } ] }'),
# %('{ "jobType": 0, "Records": [ { "s3": { "bucket": { "name": "nehdigitization" }, "object": { "key": "24153/barcode144898/PreservationMaster/barcode144898.mkv" } } } ] }'),
# %('{ "jobType": 0, "Records": [ { "s3": { "bucket": { "name": "nehdigitization" }, "object": { "key": "24153/barcode144899/PreservationMaster/barcode144899.mkv" } } } ] }'),
# %('{ "jobType": 0, "Records": [ { "s3": { "bucket": { "name": "nehdigitization" }, "object": { "key": "24153/barcode144902/PreservationMaster/barcode144902.mkv" } } } ] }'),
# %('{ "jobType": 0, "Records": [ { "s3": { "bucket": { "name": "nehdigitization" }, "object": { "key": "24153/barcode144903/PreservationMaster/barcode144903.mkv" } } } ] }'),
# %('{ "jobType": 0, "Records": [ { "s3": { "bucket": { "name": "nehdigitization" }, "object": { "key": "24153/barcode145116/PreservationMaster/barcode145116.mkv" } } } ] }'),
# %('{ "jobType": 0, "Records": [ { "s3": { "bucket": { "name": "nehdigitization" }, "object": { "key": "24153/barcode145270/PreservationMaster/barcode145270.mkv" } } } ] }'),
# %('{ "jobType": 0, "Records": [ { "s3": { "bucket": { "name": "nehdigitization" }, "object": { "key": "24153/barcode145290/PreservationMaster/barcode145290.mkv" } } } ] }'),
# %('{ "jobType": 0, "Records": [ { "s3": { "bucket": { "name": "nehdigitization" }, "object": { "key": "24153/barcode145309/PreservationMaster/barcode145309.mkv" } } } ] }'),
# %('{ "jobType": 0, "Records": [ { "s3": { "bucket": { "name": "nehdigitization" }, "object": { "key": "24153/barcode145311/PreservationMaster/barcode145311.mkv" } } } ] }'),
# %('{ "jobType": 0, "Records": [ { "s3": { "bucket": { "name": "nehdigitization" }, "object": { "key": "24153/barcode145328/PreservationMaster/barcode145328.mkv" } } } ] }'),
# %('{ "jobType": 0, "Records": [ { "s3": { "bucket": { "name": "nehdigitization" }, "object": { "key": "24153/barcode145423/PreservationMaster/barcode145423.mkv" } } } ] }'),
# %('{ "jobType": 0, "Records": [ { "s3": { "bucket": { "name": "nehdigitization" }, "object": { "key": "24153/barcode145431/PreservationMaster/barcode145431.mkv" } } } ] }'),
# %('{ "jobType": 0, "Records": [ { "s3": { "bucket": { "name": "nehdigitization" }, "object": { "key": "24153/barcode145479/PreservationMaster/barcode145479.mkv" } } } ] }'),
# %('{ "jobType": 0, "Records": [ { "s3": { "bucket": { "name": "nehdigitization" }, "object": { "key": "24153/barcode145508/PreservationMaster/barcode145508.mkv" } } } ] }'),
# %('{ "jobType": 0, "Records": [ { "s3": { "bucket": { "name": "nehdigitization" }, "object": { "key": "24153/barcode145509/PreservationMaster/barcode145509.mkv" } } } ] }'),
# %('{ "jobType": 0, "Records": [ { "s3": { "bucket": { "name": "nehdigitization" }, "object": { "key": "24153/barcode145524/PreservationMaster/barcode145524.mkv" } } } ] }'),
# %('{ "jobType": 0, "Records": [ { "s3": { "bucket": { "name": "nehdigitization" }, "object": { "key": "24153/barcode145526/PreservationMaster/barcode145526.mkv" } } } ] }'),
# %('{ "jobType": 0, "Records": [ { "s3": { "bucket": { "name": "nehdigitization" }, "object": { "key": "24153/barcode145530/PreservationMaster/barcode145530.mkv" } } } ] }'),
# %('{ "jobType": 0, "Records": [ { "s3": { "bucket": { "name": "nehdigitization" }, "object": { "key": "24153/barcode145531/PreservationMaster/barcode145531.mkv" } } } ] }'),
# %('{ "jobType": 0, "Records": [ { "s3": { "bucket": { "name": "nehdigitization" }, "object": { "key": "24153/barcode145903/PreservationMaster/barcode145903.mkv" } } } ] }'),
# %('{ "jobType": 0, "Records": [ { "s3": { "bucket": { "name": "nehdigitization" }, "object": { "key": "24153/barcode151502/PreservationMaster/barcode151502.mkv" } } } ] }'),
# %('{ "jobType": 0, "Records": [ { "s3": { "bucket": { "name": "nehdigitization" }, "object": { "key": "24153/barcode153252/PreservationMaster/barcode153252.mkv" } } } ] }'),
# %('{ "jobType": 0, "Records": [ { "s3": { "bucket": { "name": "nehdigitization" }, "object": { "key": "24153/barcode153253/PreservationMaster/barcode153253.mkv" } } } ] }'),
# %('{ "jobType": 0, "Records": [ { "s3": { "bucket": { "name": "nehdigitization" }, "object": { "key": "24153/barcode197187/PreservationMaster/barcode197187.mkv" } } } ] }'),
# %('{ "jobType": 0, "Records": [ { "s3": { "bucket": { "name": "nehdigitization" }, "object": { "key": "24153/barcode197188/PreservationMaster/barcode197188.mkv" } } } ] }'),
# %('{ "jobType": 0, "Records": [ { "s3": { "bucket": { "name": "nehdigitization" }, "object": { "key": "24153/barcode197191/PreservationMaster/barcode197191.mkv" } } } ] }'),
# %('{ "jobType": 0, "Records": [ { "s3": { "bucket": { "name": "nehdigitization" }, "object": { "key": "24153/barcode197386/PreservationMaster/barcode197386.mkv" } } } ] }'),
# %('{ "jobType": 0, "Records": [ { "s3": { "bucket": { "name": "nehdigitization" }, "object": { "key": "24153/barcode197387/PreservationMaster/barcode197387.mkv" } } } ] }'),
# %('{ "jobType": 0, "Records": [ { "s3": { "bucket": { "name": "nehdigitization" }, "object": { "key": "24153/barcode253093/PreservationMaster/barcode253093.mkv" } } } ] }'),
# %('{ "jobType": 0, "Records": [ { "s3": { "bucket": { "name": "nehdigitization" }, "object": { "key": "24153/barcode253094/PreservationMaster/barcode253094.mkv" } } } ] }'),
# %('{ "jobType": 0, "Records": [ { "s3": { "bucket": { "name": "nehdigitization" }, "object": { "key": "24153/barcode253095/PreservationMaster/barcode253095.mkv" } } } ] }'),
# %('{ "jobType": 0, "Records": [ { "s3": { "bucket": { "name": "nehdigitization" }, "object": { "key": "24153/barcode253096/PreservationMaster/barcode253096.mkv" } } } ] }'),
# %('{ "jobType": 0, "Records": [ { "s3": { "bucket": { "name": "nehdigitization" }, "object": { "key": "24153/barcode253097/PreservationMaster/barcode253097.mkv" } } } ] }'),
# %('{ "jobType": 0, "Records": [ { "s3": { "bucket": { "name": "nehdigitization" }, "object": { "key": "24153/barcode259272/PreservationMaster/barcode259272.mkv" } } } ] }'),
# %('{ "jobType": 0, "Records": [ { "s3": { "bucket": { "name": "nehdigitization" }, "object": { "key": "24321/barcode181159/PreservationMaster/barcode181159.mkv" } } } ] }'),
# %('{ "jobType": 0, "Records": [ { "s3": { "bucket": { "name": "nehdigitization" }, "object": { "key": "24321/barcode181168/PreservationMaster/barcode181168.mkv" } } } ] }'),
# %('{ "jobType": 0, "Records": [ { "s3": { "bucket": { "name": "nehdigitization" }, "object": { "key": "24321/barcode181601/PreservationMaster/barcode181601.mkv" } } } ] }'),
# %('{ "jobType": 0, "Records": [ { "s3": { "bucket": { "name": "nehdigitization" }, "object": { "key": "24321/barcode181602/PreservationMaster/barcode181602.mkv" } } } ] }'),
# %('{ "jobType": 0, "Records": [ { "s3": { "bucket": { "name": "nehdigitization" }, "object": { "key": "25606/barcode24053/PreservationMaster/barcode24053.mkv" } } } ] }'),
# %('{ "jobType": 0, "Records": [ { "s3": { "bucket": { "name": "nehdigitization" }, "object": { "key": "25606/barcode253090/PreservationMaster/barcode253090.mkv" } } } ] }'),
# %('{ "jobType": 0, "Records": [ { "s3": { "bucket": { "name": "nehdigitization" }, "object": { "key": "25606/barcode253092/PreservationMaster/barcode253092.mkv" } } } ] }'),
# %('{ "jobType": 0, "Records": [ { "s3": { "bucket": { "name": "nehdigitization" }, "object": { "key": "25606/barcode267965/PreservationMaster/barcode267965.mkv" } } } ] }'),
# %('{ "jobType": 0, "Records": [ { "s3": { "bucket": { "name": "nehdigitization" }, "object": { "key": "25606/barcode273140/PreservationMaster/barcode273140.mkv" } } } ] }'),






]

keys.each do |key|
  send_message(queue_url, key)
end

# # november batch
# sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "24153/barcode144878/PreservationMaster/barcode144878.mkv"}) })
puts "Wa-hahhh!!!"
