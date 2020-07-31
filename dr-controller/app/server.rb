require 'sinatra'
require 'mysql2'

# this little server allows an ffmpeg pod to tell the controller that its transcode is done
@client = Mysql2::Client.new(host: "mysql", username: "root", database: "drtranscode", password: "", port: 3306)
get '/update' do
  status = params[:status]
  uid = params[:uid]
  resp = @client.query(%(UPDATE jobs SET status=#{status} WHERE uid="#{uid}"))
  return 200, "Updated #{uid} to #{status}"
end