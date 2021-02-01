function output_file_exists {
  aws --endpoint-url 'http://s3-bos.wgbh.org' s3api head-object --bucket $DRTRANSCODE_BUCKET --key $DRTRANSCODE_OUTPUT_KEY &> /dev/null
}

function error_file_exists {
  errorfilename="dr-transcode-errors/error-${DRTRANSCODE_UID}.txt"
  aws --endpoint-url 'http://s3-bos.wgbh.org' s3api head-object --bucket $DRTRANSCODE_BUCKET --key $errorfilename &> /dev/null
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
    echo "Output file already exists, I've no purpose in this world... Goodbye!"
    exit 0
fi

if error_file_exists;
  then
    echo "Error file found, I should fail this job... Bye!"
    exit 0
fi

echo "Downloading input file..."
aws --endpoint-url 'http://s3-bos.wgbh.org' s3api get-object --bucket $DRTRANSCODE_BUCKET --key $DRTRANSCODE_INPUT_KEY $DRTRANSCODE_INPUT_FILENAME

echo "Running ffprobe..."
ffprobe_output=$( ffprobe $DRTRANSCODE_INPUT_FILENAME 2>&1  )
ffprobe_return="${PIPESTATUS[0]}"

echo "ffprobe returned $ffprobe_return"
if "$ffprobe_return" -ne "0";
then
  echo "ffprobe returned nonzero code... $ffprobe_return"
fi

if [[ $( echo "$ffprobe_output"  | grep "moov atom not found") || "$ffprobe_return" -ne "0" ]]
  then
  echo "Failed ffprobe, writing error file..."
  errorfilepath="dr-transcode-errors/error-${DRTRANSCODE_UID}.txt"
  errorfilename="error-${DRTRANSCODE_UID}.txt"
  echo "$ffprobe_output" > "$errorfilename"
  aws --endpoint-url 'http://s3-bos.wgbh.org' s3api put-object --bucket $DRTRANSCODE_BUCKET --key $errorfilepath --body ./$errorfilename
  # add public acl to de error txt file
  aws --endpoint-url 'http://s3-bos.wgbh.org' s3api put-object-acl --bucket $DRTRANSCODE_BUCKET --key $errorfilepath --acl public-read
  exit 1
fi

# if ffprobe output contains str 16:9, use anamorphic cmmand
if [[ $( echo "$ffprobe_output"  | grep "16:9") ]]
  then
  aspect_ratio="-s 640:360"
else
  aspect_ratio="-s 480:360"
fi

echo "Chose aspect ratio setting $aspect_ratio"

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


echo "ffmpeg output..."
echo "$ffmpeg_output"

if "$ffmpeg_return" -ne "0";
then
  echo "Messed up ffmpeg... trying to record error output for $DRTRANSCODE_UID"
  
  # pipe error output to tempfile
  errorfilename="error-${DRTRANSCODE_UID}.txt"
  echo "$ffmpeg_output" > "$errorfilename"
  aws --endpoint-url 'http://s3-bos.wgbh.org' s3api put-object --bucket $DRTRANSCODE_BUCKET --key $errorfilename --body ./$errorfilename
  # add public acl to de error txt file
  aws --endpoint-url 'http://s3-bos.wgbh.org' s3api put-object-acl --bucket $DRTRANSCODE_BUCKET --key $errorfilename --acl public-read
  exit 1
fi

# # upload output file to s3
aws --endpoint-url 'http://s3-bos.wgbh.org' s3api put-object --bucket $DRTRANSCODE_BUCKET --key $DRTRANSCODE_OUTPUT_KEY --body ./$DRTRANSCODE_OUTPUT_FILENAME

# add public acl to de file
aws --endpoint-url 'http://s3-bos.wgbh.org' s3api put-object-acl --bucket $DRTRANSCODE_BUCKET --key $DRTRANSCODE_OUTPUT_KEY --acl public-read
