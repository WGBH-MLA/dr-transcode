# download input file
cd /root


# exit
[ -z "$DRTRANSCODE_BUCKET" ] && [ -z "$DRTRANSCODE_INPUT_KEY" ] && [ -z "$DRTRANSCODE_INPUT_FILENAME" ] && [ -z "$DRTRANSCODE_OUTPUT_FILENAME" ] && [ -z "$DRTRANSCODE_OUTPUT_KEY" ] && echo "Missing DRTRANSCODE env variables, bye bye!" && exit 1
# stay open...
# [ -z "$DRTRANSCODE_BUCKET" ] && [ -z "$DRTRANSCODE_INPUT_KEY" ] && [ -z "$DRTRANSCODE_INPUT_FILENAME" ] && [ -z "$DRTRANSCODE_OUTPUT_FILENAME" ] && [ -z "$DRTRANSCODE_OUTPUT_KEY" ] && echo "Missing DRTRANSCODE env variables, bye bye!" && tail -f /dev/null

aws --endpoint-url 'http://s3-bos.wgbh.org' s3api get-object --bucket $DRTRANSCODE_BUCKET --key $DRTRANSCODE_INPUT_KEY $DRTRANSCODE_INPUT_FILENAME

# cat /root/.aws/credentials
# aws --endpoint-url 'http://s3-bos.wgbh.org' s3api list-objects --bucket neh-digi-test

# test for file extension to know which command to run


# run video transcode
if [[ "$DRTRANSCODE_INPUT_FILENAME" == *mkv ]]
  then
  ffmpeg -i $DRTRANSCODE_INPUT_FILENAME -vcodec libx264 -pix_fmt yuv420p -b:v 711k -s 480:360 -acodec aac -ac 2 -b:a 128k -metadata creation_time=now $DRTRANSCODE_OUTPUT_FILENAME
fi

# run audio transcode
if [[ "$DRTRANSCODE_INPUT_FILENAME" == *wav ]]
  then
  # mp4 extension in output filename will correctly wrap aac in mp4 container
  ffmpeg -i $DRTRANSCODE_INPUT_FILENAME -acodec aac $DRTRANSCODE_OUTPUT_FILENAME
fi

# # upload output file to s3
aws --endpoint-url 'http://s3-bos.wgbh.org' s3api put-object --bucket $DRTRANSCODE_BUCKET --key $DRTRANSCODE_OUTPUT_KEY --body ./$DRTRANSCODE_OUTPUT_FILENAME
