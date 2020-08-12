require 'csv'
require 'mysql2'
@client = Mysql2::Client.new(host: "mysql", username: "root", database: "drtranscode", password: "", port: 3306)

jobs = @client.query("SELECT * FROM jobs")
CSV.open("alljobs-#{ Time.now.strftime("%m-%e-%y-%H:%M") }.csv", "wb") do |csv|
  csv << ['UID', "JobStatus", "Input Filepath", "Fail Reason"]
  
  jobs.each do |job|
    csv << [ job["uid"], job["status"], job["input_filepath"], job["fail_reason"] ]
  end
end

jobs = @client.query("SELECT * FROM jobs WHERE status=3")
missing = jobs.uniq {|job| job["input_filepath"]}

puts missing.inspect

CSV.open("missing-#{ Time.now.strftime("%m-%e-%y-%H:%M") }.csv", "wb") do |csv|
  csv << ['UID', "JobStatus", "Input Filepath", "Fail Reason"]

  missing.each do |job|
    if(job["fail_reason"] && job["fail_reason"].include?("not found") )
      csv << [ job["uid"], job["status"], job["input_filepath"], job["fail_reason"] ]
    end
  end
end
