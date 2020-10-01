require 'aws-sdk-sqs'
puts "Dohh!"
sqs = Aws::SQS::Client.new(
  region: 'us-east-1',
  access_key_id: ENV['SQS_ACCESS_KEY_ID'],
  secret_access_key: ENV['SQS_SECRET_ACCESS_KEY']
)

puts "Woo-hoo!"
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "23797/barcode241093/PreservationMaster/barcode241093.mov"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "23797/barcode241097/PreservationMaster/barcode241097.mov"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "23797/barcode241109/PreservationMaster/barcode241109.mov"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "23797/barcode241110/PreservationMaster/barcode241110.mov"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "23797/barcode241105/PreservationMaster/barcode241105.mov"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "23797/barcode241104/PreservationMaster/barcode241104.mov"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "23797/barcode241099/PreservationMaster/barcode241099.mov"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "23797/barcode241112/PreservationMaster/barcode241112.mov"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "24082/barcode254921/PreservationMaster/barcode254921.mkv"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "24082/barcode196387/PreservationMaster/barcode196387.mkv"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "23797/barcode241123/PreservationMaster/barcode241123.mov"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "24082/barcode196379/PreservationMaster/barcode196379.mkv"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "24132/barcode191630/PreservationMaster/barcode191630_01.wav"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "24040/barcode267873/PreservationMaster/barcode267873_01.wav"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "24132/barcode224973/PreservationMaster/barcode224973_01.wav"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "24119/barcode164387/PreservationMaster/barcode164387.mkv"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "24082/barcode190443/PreservationMaster/barcode190443.mkv"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "24082/barcode165406/PreservationMaster/barcode165406.mkv"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "24083/barcode203577/PreservationMaster/barcode203577_01.wav"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "24063/barcode221439/PreservationMaster/barcode221439_01.wav"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "24083/barcode222017/PreservationMaster/barcode222017_01.wav"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "24083/barcode221721/PreservationMaster/barcode221721_01.wav"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "24083/barcode203590/PreservationMaster/barcode203590_01.wav"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "24083/barcode153365/PreservationMaster/barcode153365_01.wav"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "24132/barcode221427/PreservationMaster/barcode221427_01.wav"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "24083/barcode221761/PreservationMaster/barcode221761_01.wav"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "24083/barcode221965/PreservationMaster/barcode221965_01.wav"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "24083/barcode221937/PreservationMaster/barcode221937_01.wav"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "24132/barcode224208/PreservationMaster/barcode224208_01.wav"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "24083/barcode153355/PreservationMaster/barcode153355_01.wav"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "24083/barcode153338/PreservationMaster/barcode153338_01.wav"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "24083/barcode221790/PreservationMaster/barcode221790_01.wav"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "24083/barcode156244/PreservationMaster/barcode156244_01.wav"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "23968/barcode65029/PreservationMaster/barcode65029.mkv"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "24082/barcode196633/PreservationMaster/barcode196633.mkv"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "24082/barcode127729/PreservationMaster/barcode127729.mkv"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "24083/barcode222141/PreservationMaster/barcode222141_01.wav"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "24132/barcode152789/PreservationMaster/barcode152789_01.wav"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "24063/barcode203603/PreservationMaster/barcode203603_01.wav"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "24082/barcode196464/PreservationMaster/barcode196464.mkv"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "24063/barcode255734/PreservationMaster/barcode255734_01.wav"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "24082/barcode254902/PreservationMaster/barcode254902.mkv"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "24083/barcode221659/PreservationMaster/barcode221659_01.wav"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "24083/barcode153152/PreservationMaster/barcode153152_01.wav"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "24063/barcode221924/PreservationMaster/barcode221924_01.wav"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "24083/barcode153369/PreservationMaster/barcode153369_01.wav"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "24132/barcode221365/PreservationMaster/barcode221365_01.wav"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "24063/barcode255748/PreservationMaster/barcode255748_01.wav"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "24082/barcode196467/PreservationMaster/barcode196467.mkv"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "24083/barcode153337/PreservationMaster/barcode153337_01.wav"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "24082/barcode196191/PreservationMaster/barcode196191.mkv"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "24132/barcode221116/PreservationMaster/barcode221116_01.wav"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "24083/barcode194884/PreservationMaster/barcode194884_01.wav"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "24132/barcode191479/PreservationMaster/barcode191479_01.wav"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "24132/barcode225072/PreservationMaster/barcode225072_01.wav"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "24132/barcode224282/PreservationMaster/barcode224282_01.wav"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "24132/barcode221934/PreservationMaster/barcode221934_01.wav"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "24063/barcode221648/PreservationMaster/barcode221648_01.wav"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "24083/barcode221996/PreservationMaster/barcode221996_01.wav"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "24083/barcode221966/PreservationMaster/barcode221966_01.wav"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "24083/barcode153358/PreservationMaster/barcode153358_01.wav"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "24083/barcode221707/PreservationMaster/barcode221707_01.wav"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "24132/barcode221481/PreservationMaster/barcode221481_01.wav"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "24082/barcode229366/PreservationMaster/barcode229366.mkv"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "24082/barcode196410/PreservationMaster/barcode196410.mkv"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "24063/barcode255647/PreservationMaster/barcode255647_01.wav"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "24083/barcode153354/PreservationMaster/barcode153354_01.wav"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "24083/barcode155288/PreservationMaster/barcode155288_01.wav"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "24063/barcode255423/PreservationMaster/barcode255423_01.wav"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "24063/barcode255229/PreservationMaster/barcode255229_01.wav"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "24063/barcode255379/PreservationMaster/barcode255379_01.wav"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "24063/barcode255381/PreservationMaster/barcode255381_01.wav"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "24082/barcode224497/PreservationMaster/barcode224497.mkv"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "24063/barcode255730/PreservationMaster/barcode255730_01.wav"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "24063/barcode255658/PreservationMaster/barcode255658_01.wav"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "24063/barcode255626/PreservationMaster/barcode255626_01.wav"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "24083/barcode194910/PreservationMaster/barcode194910_01.wav"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "24063/barcode255738/PreservationMaster/barcode255738_01.wav"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "24082/barcode225574/PreservationMaster/barcode225574.mkv"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "24083/barcode221710/PreservationMaster/barcode221710_01.wav"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "24063/barcode255728/PreservationMaster/barcode255728_01.wav"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "24119/barcode148271/PreservationMaster/barcode148271.mkv"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "24063/barcode255419/PreservationMaster/barcode255419_01.wav"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "24083/barcode153362/PreservationMaster/barcode153362_01.wav"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "24083/barcode202862/PreservationMaster/barcode202862_01.wav"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "24082/barcode196352/PreservationMaster/barcode196352.mkv"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "24082/barcode159512/PreservationMaster/barcode159512.mkv"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "24082/barcode150278/PreservationMaster/barcode150278.mkv"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "24083/barcode153356/PreservationMaster/barcode153356_01.wav"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "23883/barcode229163/PreservationMaster/barcode229163_01.wav"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "24119/barcode148760/PreservationMaster/barcode148760.mkv"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "24082/barcode147350/PreservationMaster/barcode147350.mkv"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "23968/barcode106523/PreservationMaster/barcode106523.mkv"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "24083/barcode224206/PreservationMaster/barcode224206_01.wav"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "24083/barcode222008/PreservationMaster/barcode222008_01.wav"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "24083/barcode221993/PreservationMaster/barcode221993_01.wav"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "24083/barcode221995/PreservationMaster/barcode221995_01.wav"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "24082/barcode147353/PreservationMaster/barcode147353.mkv"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "24119/barcode148298/PreservationMaster/barcode148298.mkv"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "24119/barcode148288/PreservationMaster/barcode148288.mkv"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "24082/barcode160272/PreservationMaster/barcode160272.mkv"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "24119/barcode160287/PreservationMaster/barcode160287.mkv"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "24063/barcode255293/PreservationMaster/barcode255293_01.wav"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "24119/barcode148300/PreservationMaster/barcode148300.mkv"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "24082/barcode160281/PreservationMaster/barcode160281.mkv"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "24083/barcode155870/PreservationMaster/barcode155870_01.wav"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "24119/barcode201737/PreservationMaster/barcode201737.mkv"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "24082/barcode160282/PreservationMaster/barcode160282.mkv"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "24082/barcode160275/PreservationMaster/barcode160275.mkv"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "24063/barcode255733/PreservationMaster/barcode255733_01.wav"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "24063/barcode255651/PreservationMaster/barcode255651_01.wav"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "23928/barcode176327/PreservationMaster/barcode176327.mkv"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "23968/barcode254212/PreservationMaster/barcode254212.mkv"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "24083/barcode221754/PreservationMaster/barcode221754_01.wav"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "24083/barcode221845/PreservationMaster/barcode221845_01.wav"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "24082/barcode98219/PreservationMaster/barcode98219.mkv"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "24083/barcode229343/PreservationMaster/barcode229343_01.wav"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "24063/barcode222103/PreservationMaster/barcode222103_01.wav"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "24083/barcode202889/PreservationMaster/barcode202889_01.wav"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "24083/barcode178645/PreservationMaster/barcode178645_01.wav"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "24083/barcode202939/PreservationMaster/barcode202939_01.wav"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "23968/barcode41026/PreservationMaster/barcode41026.mkv"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "24063/barcode255760/PreservationMaster/barcode255760_01.wav"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "24063/barcode255764/PreservationMaster/barcode255764_01.wav"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "24063/barcode255727/PreservationMaster/barcode255727_01.wav"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "24083/barcode153241/PreservationMaster/barcode153241_01.wav"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "24119/barcode163159/PreservationMaster/barcode163159.mkv"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "23928/barcode176320/PreservationMaster/barcode176320.mkv"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "24119/barcode147355/PreservationMaster/barcode147355.mkv"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "24063/barcode255494/PreservationMaster/barcode255494_01.wav"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "24132/barcode156216/PreservationMaster/barcode156216_01.wav"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "24119/barcode192375/PreservationMaster/barcode192375.mkv"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "23928/barcode176328/PreservationMaster/barcode176328.mkv"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "23968/barcode383167/PreservationMaster/barcode383167.mkv"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "23928/barcode176010/PreservationMaster/barcode176010.mkv"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "23928/barcode176330/PreservationMaster/barcode176330.mkv"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "24119/barcode201733/PreservationMaster/barcode201733.mkv"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "24082/barcode196476/PreservationMaster/barcode196476.mkv"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "24082/barcode245226/PreservationMaster/barcode245226.mkv"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "24082/barcode245577/PreservationMaster/barcode245577.mkv"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "24119/barcode149198/PreservationMaster/barcode149198.mkv"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "24119/barcode148666/PreservationMaster/barcode148666.mkv"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "24119/barcode149197/PreservationMaster/barcode149197.mkv"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "23928/barcode246187/PreservationMaster/barcode246187.mkv"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "24082/barcode201658/PreservationMaster/barcode201658.mkv"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "24082/barcode240744/PreservationMaster/barcode240744.mkv"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "24082/barcode132861/PreservationMaster/barcode132861.mkv"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "23928/barcode369392/PreservationMaster/barcode369392.mkv"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "23928/barcode11209/PreservationMaster/barcode11209.mkv"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "23920/barcode382883/PreservationMaster/barcode382883.mkv"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "24119/barcode148739/PreservationMaster/barcode148739.mkv"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "23920/barcode27061/PreservationMaster/barcode27061.mkv"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "23920/barcode96572/PreservationMaster/barcode96572.mkv"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "23920/barcode382876/PreservationMaster/barcode382876.mkv"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "23920/barcode382863/PreservationMaster/barcode382863.mkv"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "24082/barcode245050/PreservationMaster/barcode245050.mkv"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "23928/barcode20777/PreservationMaster/barcode20777.mkv"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "23928/barcode369391/PreservationMaster/barcode369391.mkv"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "23928/barcode20773/PreservationMaster/barcode20773.mkv"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "23920/barcode113994/PreservationMaster/barcode113994.mkv"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "23968/barcode67872/PreservationMaster/barcode67872.mkv"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "23912/barcode382828/PreservationMaster/barcode382828.mkv"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "24082/barcode132910/PreservationMaster/barcode132910.mkv"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "23928/barcode98595/PreservationMaster/barcode98595.mkv"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "23928/barcode19259/PreservationMaster/barcode19259.mkv"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "23928/barcode98591/PreservationMaster/barcode98591.mkv"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "23920/barcode117802/PreservationMaster/barcode117802.mkv"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "23889/barcode192362/PreservationMaster/barcode192362.mkv"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "23928/barcode21913/PreservationMaster/barcode21913.mkv"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "23920/barcode27059/PreservationMaster/barcode27059.mkv"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "24082/barcode68410/PreservationMaster/barcode68410.mkv"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "24082/barcode244839/PreservationMaster/barcode244839.mkv"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "24082/barcode245052/PreservationMaster/barcode245052.mkv"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "24082/barcode245044/PreservationMaster/barcode245044.mkv"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "24082/barcode245235/PreservationMaster/barcode245235.mkv"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "24082/barcode132911/PreservationMaster/barcode132911.mkv"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "23920/barcode382875/PreservationMaster/barcode382875.mkv"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "24063/barcode203195/PreservationMaster/barcode203195_01.wav"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "23623/barcode234477/PreservationMaster/barcode234477_01.wav"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "23623/barcode224227/PreservationMaster/barcode224227_01.wav"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "24082/barcode244834/PreservationMaster/barcode244834.mkv"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "23623/barcode155765/PreservationMaster/barcode155765_01.wav"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "23889/barcode20345/PreservationMaster/barcode20345.mkv"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "24119/barcode105467/PreservationMaster/barcode105467.mkv"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "23623/barcode294555/PreservationMaster/barcode294555_01.wav"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "24119/barcode105456/PreservationMaster/barcode105456.mkv"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "24119/barcode144126/PreservationMaster/barcode144126.mkv"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "24119/barcode102842/PreservationMaster/barcode102842.mkv"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "24082/barcode146880/PreservationMaster/barcode146880.mkv"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "24119/barcode144137/PreservationMaster/barcode144137.mkv"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "24119/barcode144084/PreservationMaster/barcode144084.mkv"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "24119/barcode236051/PreservationMaster/barcode236051.mkv"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "23857/barcode172860/PreservationMaster/barcode172860.mkv"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "24119/barcode144144/PreservationMaster/barcode144144.mkv"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "24119/barcode144109/PreservationMaster/barcode144109.mkv"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "24082/barcode180715/PreservationMaster/barcode180715.mkv"}) })
sqs.send_message({ queue_url: "https://sqs.us-east-1.amazonaws.com/127946490116/dr-transcode-queue", message_body: %({"input_filepath": "24119/barcode105469/PreservationMaster/barcode105469.mkv"}) })



puts "Wa-hahhh!!!"