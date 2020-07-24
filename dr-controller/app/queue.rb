require 'aws-sdk-sqs'


# load queue...
# queue = Sqs.whatever

# load db..
client = Mysql2::Client.new(:host => "mysql", :username => "root")



while true

  # read queue...
end



CREATE TABLE status (status INTEGER, input_filename VARCHAR(1024);