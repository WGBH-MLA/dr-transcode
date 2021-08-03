File.read("wowall.txt").split("\n").each do |streamo|
  key = streamo.gsub("https://hls-streaming.mla-int.wgbh.org/avalon/", "").gsub("/master.m3u8", "")

  puts "Checking #{key}"

  resp=`aws --endpoint-url 'http://s3-bos.wgbh.org' s3api get-object-acl --bucket streaming-proxies --key #{key} |grep '"Permission": "READ"'`

  if resp.empty?
    puts "Not Found! ACLing..."
    `aws --endpoint-url 'http://s3-bos.wgbh.org' s3api put-object-acl --bucket streaming-proxies --key #{key}  --acl public-read`
  end
end
