require 'mysql2'
require 'securerandom'
require 'json'
require 'pathname'
require 'fileutils'
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

# allNew = @client.query("SELECT * FROM jobs WHERE status=100 LIMIT 100")
File.open("tsKeyPresence.txt", "w+") do |f|
  File.read("ts-check.txt").split("\n").each do|uid|

    raise "OOF!" unless !uid.empty?
    job = @client.query(%(SELECT * FROM jobs WHERE uid="#{uid}")).first
    # size = `aws --endpoint-url 'http://s3-bos.wgbh.org' s3api head-object --bucket #{job["input_bucketname"]} --key #{job["input_filepath"]} |grep ContentLength`.gsub(/\D/, "")

    # output_key = "#{File.basename(job["input_filepath"],'.*')}.mp4"
    output_key = %(#{job["input_bucketname"]}/#{Pathname.new(job["input_filepath"]).sub_ext(".mp4")})

    presence = !(`aws --endpoint-url 'http://s3-bos.wgbh.org' s3api head-object --bucket streaming-proxies --key #{ output_key }`).empty?
    lineup = %(#{job["uid"]},#{job["input_bucketname"]},#{job["input_filepath"]},#{output_key},#{presence}\n)
    puts lineup
    f << lineup
  end
end
