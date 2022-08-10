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
File.read("27733-keys.txt").split("\n").each do |key|

  uid = SecureRandom.uuid
  input_bucketname = "nehdigitization"

  query = %(INSERT INTO jobs (uid, status, input_filepath, job_type, input_bucketname) VALUES("#{uid}", #{JobStatus::Received}, "#{key}", #{JobType::CreateProxy}, "#{input_bucketname}"))
  puts "Now doing..."
  puts query
  @client.query(query)
end
