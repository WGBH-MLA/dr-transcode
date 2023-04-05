  # require 'mysql2'
  require 'securerandom'
  require 'json'
  require 'pathname'

  def duration(filepath)
    `ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 #{filepath}`.to_f
  end
  # @client = Mysql2::Client.new(host: "mysql", username: "root", database: "drtranscode", password: "", port: 3306)


  File.open("audit-status2-01-30-23.csv", "w+") do |f|

    File.read("status-2.txt").split("\n").each do |row|
      key,bucket = row.split(",")
 

      proxy_key = %(#{bucket}/#{ key.gsub(".mkv", "").gsub(".mov", "").gsub(".wav", "") }.mp4)

      localfilename = "./video/#{File.basename(key, ".*")}.mp4"
      
      puts "download #{proxy_key} to #{localfilename}"
      res = `aws --endpoint-url 'http://s3-bos.wgbh.org' s3api get-object --bucket streaming-proxies --key #{proxy_key} #{localfilename}`

      puts res

      dur = duration(localfilename)
      puts "duration was #{dur}"

      f << %(#{ bucket },#{ key },#{proxy_key},#{dur},#{Time.at(dur).utc.strftime("%H:%M:%S") }\n)

      puts "Deleting #{localfilename}"
      `rm ./video/*`
    end
  end



  #   File.read("100-proxy-mp4.txt").split("\n").each do |key|
  #     localfilename = "./video/#{File.basename(key)}"
  #     puts "download #{key} to #{localfilename}"
  #     res = `aws --endpoint-url 'http://s3-bos.wgbh.org' s3api get-object --bucket streaming-proxies --key #{key} #{localfilename}`

  #     puts res

  #     dur = duration(localfilename)
  #     puts "duration was #{dur}"

  #     f << %(#{key},#{dur},#{Time.at(dur).utc.strftime("%H:%M:%S")}\n)

  #     puts "Deleting #{key}"
  #     `rm ./video/*`
  #   end
  # end
