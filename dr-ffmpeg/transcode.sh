@client = Mysql2::Client.new(host: "mysql", username: "root", database: "drtranscode", password: "", port: 3306)


function output_file_exists {
  aws --endpoint-url 'http://s3-bos.wgbh.org' s3api head-object --bucket $DRTRANSCODE_BUCKET --key $DRTRANSCODE_OUTPUT_KEY &> /dev/null
}

# download input file
cd /root

# exit
[ -z "$DRTRANSCODE_BUCKET" ] && [ -z "$DRTRANSCODE_INPUT_KEY" ] && [ -z "$DRTRANSCODE_INPUT_FILENAME" ] && [ -z "$DRTRANSCODE_OUTPUT_FILENAME" ] && [ -z "$DRTRANSCODE_OUTPUT_KEY" ] && echo "Missing DRTRANSCODE env variables, bye bye!" && exit 1
# stay open...
# [ -z "$DRTRANSCODE_BUCKET" ] && [ -z "$DRTRANSCODE_INPUT_KEY" ] && [ -z "$DRTRANSCODE_INPUT_FILENAME" ] && [ -z "$DRTRANSCODE_OUTPUT_FILENAME" ] && [ -z "$DRTRANSCODE_OUTPUT_KEY" ] && echo "Missing DRTRANSCODE env variables, bye bye!" && tail -f /dev/null

# need to get nonzero code from this in order to proceed
if output_file_exists;
  then
    echo "File exists, I've no purpose in this world... Goodbye!"
    exit 0
fi

aws --endpoint-url 'http://s3-bos.wgbh.org' s3api get-object --bucket $DRTRANSCODE_BUCKET --key $DRTRANSCODE_INPUT_KEY $DRTRANSCODE_INPUT_FILENAME


# if ffprobe output contains str 16:9, use anamorphic cmmand
if [[ ffprobe "$DRTRANSCODE_INPUT_FILENAME" | grep "16:9" ]]
  then

  $aspect_ratio="-s 640:360"
else
  $aspect_ratio="-s 480:360"
fi

# run video transcode
if [[ "$DRTRANSCODE_INPUT_FILENAME" == *dv ]]
  then
  ffmpeg_output=$( ffmpeg -i $DRTRANSCODE_INPUT_FILENAME -vcodec libx264 -pix_fmt yuv420p -b:v 711k $aspect_ratio -acodec aac -ac 2 -b:a 128k -metadata creation_time=now $DRTRANSCODE_OUTPUT_FILENAME 2>&1 )
  ffmpeg_return="${PIPESTATUS[0]}"
fi

if [[ "$DRTRANSCODE_INPUT_FILENAME" == *mkv ]]
  then
  ffmpeg_output=$( ffmpeg -i $DRTRANSCODE_INPUT_FILENAME -vcodec libx264 -pix_fmt yuv420p -b:v 711k $aspect_ratio -acodec aac -ac 2 -b:a 128k -metadata creation_time=now $DRTRANSCODE_OUTPUT_FILENAME 2>&1 )
  ffmpeg_return="${PIPESTATUS[0]}"
fi

if [[ "$DRTRANSCODE_INPUT_FILENAME" == *mov ]]
  then
  ffmpeg_output=$( ffmpeg -i $DRTRANSCODE_INPUT_FILENAME -vcodec libx264 -pix_fmt yuv420p -b:v 711k $aspect_ratio -acodec aac -ac 2 -b:a 128k -metadata creation_time=now $DRTRANSCODE_OUTPUT_FILENAME 2>&1 )
  ffmpeg_return="${PIPESTATUS[0]}"
fi

# run audio transcode
if [[ "$DRTRANSCODE_INPUT_FILENAME" == *wav ]]
  then
  # mp4 extension in output filename will correctly wrap aac in mp4 container
  ffmpeg_output=$( ffmpeg -i $DRTRANSCODE_INPUT_FILENAME -acodec aac $DRTRANSCODE_OUTPUT_FILENAME 2>&1 )
  ffmpeg_return="${PIPESTATUS[0]}"
fi

# # run video transcode
# if [[ "$DRTRANSCODE_INPUT_FILENAME" == *dv ]]
#   then
#   ffmpeg_output=$( ffmpeg -i $DRTRANSCODE_INPUT_FILENAME -vcodec libx264 -pix_fmt yuv420p -b:v 711k -s 480:360 -acodec aac -ac 2 -b:a 128k -metadata creation_time=now $DRTRANSCODE_OUTPUT_FILENAME 2>&1 )
#   ffmpeg_return="${PIPESTATUS[0]}"
# fi

# if [[ "$DRTRANSCODE_INPUT_FILENAME" == *mkv ]]
#   then
#   ffmpeg_output=$( ffmpeg -i $DRTRANSCODE_INPUT_FILENAME -vcodec libx264 -pix_fmt yuv420p -b:v 711k -s 480:360 -acodec aac -ac 2 -b:a 128k -metadata creation_time=now $DRTRANSCODE_OUTPUT_FILENAME 2>&1 )
#   ffmpeg_return="${PIPESTATUS[0]}"
# fi

# if [[ "$DRTRANSCODE_INPUT_FILENAME" == *mov ]]
#   then
#   ffmpeg_output=$( ffmpeg -i $DRTRANSCODE_INPUT_FILENAME -vcodec libx264 -pix_fmt yuv420p -b:v 711k -s 480:360 -acodec aac -ac 2 -b:a 128k -metadata creation_time=now $DRTRANSCODE_OUTPUT_FILENAME 2>&1 )
#   ffmpeg_return="${PIPESTATUS[0]}"
# fi

if $ffmpeg_return -ne 0;
then
  echo "Messed up ffmpeg... trying to update job record for ${ DRTRANSCODE_UID } ${ ffmpeg_output }"
  # mysql -h mysql -u root -p "" -e 'UPDATE jobs SET status=3,fail_reason="Exit ${ ffmpeg_return } - ${ ffmpeg_output }" WHERE uid="${ DRTRANSCODE_UID }"'
  
  # pipe error output to tempfile
  errorfilename="error-${DRTRANSCODE_UID}.txt"
  echo "$ffmpeg_output" > "$errorfilename"
  aws --endpoint-url 'http://s3-bos.wgbh.org' s3api put-object --bucket $DRTRANSCODE_BUCKET --key $errorfilename --body ./$errorfilename
  # add public acl to de error txt file
  aws --endpoint-url 'http://s3-bos.wgbh.org' s3api put-object-acl --bucket $DRTRANSCODE_BUCKET --key $errorfilename --acl public-read
  exit 0
fi

# # upload output file to s3
aws --endpoint-url 'http://s3-bos.wgbh.org' s3api put-object --bucket $DRTRANSCODE_BUCKET --key $DRTRANSCODE_OUTPUT_KEY --body ./$DRTRANSCODE_OUTPUT_FILENAME

# add public acl to de file
aws --endpoint-url 'http://s3-bos.wgbh.org' s3api put-object-acl --bucket $DRTRANSCODE_BUCKET --key $DRTRANSCODE_OUTPUT_KEY --acl public-read
