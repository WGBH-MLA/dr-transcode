
require 'csv'
require 'mysql2'
require 'pathname'

# pass in query if you like
query = ARGV[0]

@client = Mysql2::Client.new(host: "mysql", username: "root", database: "drtranscode", password: "", port: 3306)

jobs = @client.query("SELECT * FROM jobs")
CSV.open("alljobs-#{ Time.now.strftime("%m-%e-%y-%H:%M") }.csv", "wb") do |csv|
  csv << ['UID', "JobStatus", "Job Type", "Input Filepath", "Input Bucket", "Created At", "Fail Reason"]
    
  uniquejobs = jobs.uniq {|job| job["input_filepath"]+job["input_bucketname"] }
  uniquejobs.each do |job|
    csv << [ job["uid"], job["status"], job["job_type"], job["input_filepath"], job["input_bucketname"], job["created_at"], job["fail_reason"] ]
  end
end

# query ||= "SELECT * FROM jobs ORDER BY created_at DESC"

# jobs = @client.query(query)
# # missing = jobs.select {|job| job["fail_reason"] && job["fail_reason"].include?("not found") }.uniq {|job| job["input_filepath"]}
# missing = jobs.uniq {|job| job["input_filepath"]}

# puts missing.inspect

# # CSV.open("missing-#{ Time.now.strftime("%m-%e-%y-%H:%M") }.csv", "wb") do |csv|
#   csv << ['UID', "JobStatus", "Input Filepath", "Fail Reason", "Input File Missing", "Output File Missing"]

#   input_missing = nil
#   output_missing = nil

#   missing.each do |job|
#     input_missing = `aws --endpoint-url 'http://s3-bos.wgbh.org' s3api head-object --bucket nehdigitization --key #{job["input_filepath"]}`

#     output_filepath = Pathname.new(job["input_filepath"]).sub_ext('.mp4')
#     # audio and video files are both wrapped in mp4 containers for avalon purposes
#     input_missing = `aws --endpoint-url 'http://s3-bos.wgbh.org' s3api head-object --bucket nehdigitization --key #{job["input_filepath"]}`.empty?
#     output_missing = `aws --endpoint-url 'http://s3-bos.wgbh.org' s3api head-object --bucket nehdigitization --key #{ output_filepath }`.empty?
#     csv << [ job["uid"], job["status"], job["input_filepath"], job["fail_reason"], input_missing, output_missing ]    
#   end
# end
