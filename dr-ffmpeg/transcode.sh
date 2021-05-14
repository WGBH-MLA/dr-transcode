function output_file_exists {
  aws --endpoint-url 'http://s3-bos.wgbh.org' s3api head-object --bucket $DRTRANSCODE_OUTPUT_BUCKET --key $destination_output_key &> /dev/null
}

function error_file_exists {
  errorfilename="dr-transcode-errors/error-${DRTRANSCODE_UID}.txt"
  aws --endpoint-url 'http://s3-bos.wgbh.org' s3api head-object --bucket $DRTRANSCODE_OUTPUT_BUCKET --key $errorfilename &> /dev/null
}

# download input file
cd /root

# exit
[ -z "$DRTRANSCODE_OUTPUT_BUCKET" ] && [ -z "$DRTRANSCODE_INPUT_BUCKET" ] && [ -z "$DRTRANSCODE_INPUT_KEY" ] && echo "Missing DRTRANSCODE env variables, bye bye!" && exit 1
# stay open...
# [ -z "$DRTRANSCODE_BUCKET" ] && [ -z "$DRTRANSCODE_INPUT_KEY" ] && [ -z "$DRTRANSCODE_OUTPUT_FILENAME" ] && [ -z "$destination_output_key" ] && echo "Missing DRTRANSCODE env variables, bye bye!" && tail -f /dev/null

# need to get nonzero code from this in order to proceed

echo "Building expected output filename..."
# just filename without path
filename=$(basename -- "$DRTRANSCODE_INPUT_KEY")
# chop that ext off baby
filename_no_ext=$(echo "$filename" | cut -f 1 -d '.' )

local_input_filepath=/root/"$filename"
mp4filename="$filename_no_ext".mp4
local_output_filepath=/root/"$mp4filename"

keypath=$(dirname "$DRTRANSCODE_INPUT_KEY")
# s3:streaming-proxies//< folder named after input bucket name>/<full input key path from input bucket>/< input filename but with mp4 extension >
destination_output_key="$DRTRANSCODE_INPUT_BUCKET"/"$keypath"/"$mp4filename"


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
aws --endpoint-url 'http://s3-bos.wgbh.org' s3api get-object --bucket $DRTRANSCODE_INPUT_BUCKET --key $DRTRANSCODE_INPUT_KEY $local_input_filepath

echo "Running ffprobe..."
ffprobe_output=$( ffprobe $local_input_filepath 2>&1  )
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
  aws --endpoint-url 'http://s3-bos.wgbh.org' s3api put-object --bucket $DRTRANSCODE_OUTPUT_BUCKET --key $errorfilepath --body ./$errorfilename
  # add public acl to de error txt file
  aws --endpoint-url 'http://s3-bos.wgbh.org' s3api put-object-acl --bucket $DRTRANSCODE_OUTPUT_BUCKET --key $errorfilepath --acl public-read
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
if [[ "$local_input_filepath" == *dv ]]
  then
  ffmpeg_output=$( ffmpeg -i $local_input_filepath -vcodec libx264 -pix_fmt yuv420p -b:v 711k $aspect_ratio -acodec aac -ac 2 -b:a 128k -metadata creation_time=now $local_output_filepath 2>&1 )
  ffmpeg_return="${PIPESTATUS[0]}"
fi

if [[ "$local_input_filepath" == *mkv ]]
  then
  ffmpeg_output=$( ffmpeg -i $local_input_filepath -vcodec libx264 -pix_fmt yuv420p -b:v 711k $aspect_ratio -acodec aac -ac 2 -b:a 128k -metadata creation_time=now $local_output_filepath 2>&1 )
  ffmpeg_return="${PIPESTATUS[0]}"
fi

if [[ "$local_input_filepath" == *mov ]]
  then
  ffmpeg_output=$( ffmpeg -i $local_input_filepath -vcodec libx264 -pix_fmt yuv420p -b:v 711k $aspect_ratio -acodec aac -ac 2 -b:a 128k -metadata creation_time=now $local_output_filepath 2>&1 )
  ffmpeg_return="${PIPESTATUS[0]}"
fi

# run audio transcode
if [[ "$local_input_filepath" == *wav ]]
  then
  # mp4 extension in output filename will correctly wrap aac in mp4 container
  ffmpeg_output=$( ffmpeg -i $local_input_filepath -acodec aac $local_output_filepath 2>&1 )
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
aws --endpoint-url 'http://s3-bos.wgbh.org' s3api put-object --bucket $DRTRANSCODE_BUCKET --key $destination_output_key --body ./$local_output_filepath

# add public acl to de file
aws --endpoint-url 'http://s3-bos.wgbh.org' s3api put-object-acl --bucket $DRTRANSCODE_BUCKET --key $destination_output_key --acl public-read
