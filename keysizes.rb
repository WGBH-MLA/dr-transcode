require 'mysql2'
require 'securerandom'
require 'json'
require 'pathname'
module JobStatus
  Received = 0
  Working = 1
  CompletedWork = 2
  Failed = 3
end

module JobType
  # default
  CreateProxy = 0
  PreserveLeftAudio = 1
  PreserveRightAudio = 2
end

# load db..
@client = Mysql2::Client.new(host: "mysql", username: "root", database: "drtranscode", password: "", port: 3306)
allNew = @client.query("SELECT * FROM jobs WHERE status=100 LIMIT 100")
File.open("keySizes.txt", "w+") do |f|
  
  allNew.each do |job|
    size = `aws --endpoint-url 'http://s3-bos.wgbh.org' s3api head-object --bucket #{job["input_bucketname"]} --key #{job["input_filepath"]} |grep ContentLength`.gsub(/\D/, "")
    lineup = %(#{job["uid"]},#{job["input_bucketname"]},#{job["input_filepath"]},#{size}\n)
    puts lineup
    f << lineup
  end
end
