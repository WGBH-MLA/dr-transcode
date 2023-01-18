  require 'mysql2'
  require 'securerandom'
  require 'json'
  require 'pathname'

  def duration(filepath)
    `ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 #{filepath}`.to_f
  end
  @client = Mysql2::Client.new(host: "mysql", username: "root", database: "drtranscode", password: "", port: 3306)

  seenKeys={}

  File.open("audit10k.csv", "w+") do |f|

    @client.query("select * from jobs where status=2 and job_type=0 and created_at >= '2022-04-01 00:00:00'").each do |job|
 
      if seenKeys[ job["input_filepath"] ]
        puts "seen #{job["input_filepath"]} already, skiping........"
        next
      else
        seenKeys[ job["input_filepath"] ] = true
      end

      proxy_key = %(#{job["input_bucketname"]}/#{ job["input_filepath"].gsub(File.basename(job["input_filepath"]), "") }#{File.basename(job["input_filepath"], ".*")}.mp4)

      localfilename = "./video/#{File.basename(job["input_filepath"], ".*")}.mp4"
      
      puts "download #{proxy_key} to #{localfilename}"
      res = `aws --endpoint-url 'http://s3-bos.wgbh.org' s3api get-object --bucket streaming-proxies --key #{proxy_key} #{localfilename}`

      puts res

      dur = duration(localfilename)
      puts "duration was #{dur}"

      f << %(#{File.basename(job["input_filepath"], ".*").gsub("barcode", "")},#{job["input_bucketname"]},#{job["input_filepath"]},#{proxy_key},#{dur},#{Time.at(dur).utc.strftime("%H:%M:%S")},#{job["created_at"]},#{job["job_start_time"] || 0},#{job["job_end_time"] || 0}\n)

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
