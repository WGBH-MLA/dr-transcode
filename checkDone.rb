File.read("27333-finished-72022.txt").split("\n").each do |key|
  resp = `aws --endpoint-url 'http://s3-bos.wgbh.org' s3api head-object --bucket streaming-proxies --key #{key}`
  puts resp
end
