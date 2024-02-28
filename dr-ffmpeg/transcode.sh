function output_file_exists {
  aws --endpoint-url 'http://s3-bos.wgbh.org' s3api head-object --bucket $DRTRANSCODE_OUTPUT_BUCKET --key $destination_output_key &> /dev/null
}

function error_file_exists {
  errorfilename="dr-transcode-errors/error-${DRTRANSCODE_UID}.txt"
  aws --endpoint-url 'http://s3-bos.wgbh.org' s3api head-object --bucket $DRTRANSCODE_OUTPUT_BUCKET --key $errorfilename &> /dev/null
}

function increment_retry_file {
  retryfilename="retry-${DRTRANSCODE_UID}.txt"
  
  # get retry count file

  echo "obviously my retry filename is ${retryfilename} and full key is dr-transcode-retries/${retryfilename}"
  aws --endpoint-url 'http://s3-bos.wgbh.org' s3api get-object --bucket $DRTRANSCODE_OUTPUT_BUCKET --key "dr-transcode-retries/${retryfilename}" $retryfilename

  if [[ -n "$retryfilename" && -f $retryfilename ]]
  then
    retry_count=$(cat ${retryfilename})
    retry_count=$(($retry_count+1))
    echo "I now increment to ${retry_count}"
    echo $retry_count > $retryfilename
  else
    echo " i set retry to zero!"
    echo 0 > $retryfilename
  fi

  # write new retry count to file
  echo "and you can see that $(cat $retryfilename)"

  aws --endpoint-url 'http://s3-bos.wgbh.org' s3api put-object --bucket $DRTRANSCODE_OUTPUT_BUCKET --key "dr-transcode-retries/${retryfilename}" --body $retryfilename
}

function duration {
  out=$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 $1)
  if [ -z "$out" ];
    then
      echo 0
      # otherwise default 0
    else
      # if output present then send it
      echo "${out}"
  fi
}

echo "Let us begin!"

# exit
[ -z "$DRTRANSCODE_OUTPUT_BUCKET" ] && [ -z "$DRTRANSCODE_INPUT_BUCKET" ] && [ -z "$DRTRANSCODE_INPUT_KEY" ] && echo "Missing DRTRANSCODE env variables, bye bye!" && exit 1

# download input file
workspace_folder=/workspace/"$DRTRANSCODE_UID"
# temp v
# workspace_folder=/root/"$DRTRANSCODE_UID"


echo "Building expected output filename..."
# just filename without path
filename=$(basename -- "$DRTRANSCODE_INPUT_KEY")
# chop that ext off baby
filename_no_ext=$(echo "$filename" | cut -f 1 -d '.' )

local_input_filepath="$workspace_folder"/"$filename"
mp4filename="$filename_no_ext".mp4
local_output_filepath=$workspace_folder/"$mp4filename"

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

mkdir -p $workspace_folder
cd $workspace_folder

echo "LISTEN"
echo "Downloading input file to $local_input_filepath..."
# aws --endpoint-url 'http://s3-bos.wgbh.org' s3api get-object --bucket $DRTRANSCODE_INPUT_BUCKET --key $DRTRANSCODE_INPUT_KEY $local_input_filepath
# redirect stderr to this var
download_output=$(aws --endpoint-url 'http://s3-bos.wgbh.org' s3api get-object --bucket $DRTRANSCODE_INPUT_BUCKET --key $DRTRANSCODE_INPUT_KEY $local_input_filepath 2>&1)
if [[ $download_output == *"read, but total bytes expected is"* ]]; then
  # if we got the bad thing, say NO
  echo "Did not receive the whole file from S3, increment retry file, delete, and try again!!"
  rm -rf "$workspace_folder"
  increment_retry_file
  exit 1
fi


echo "Running ffprobe to check aspect ratio..."
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
  echo "Detected dv file, doing ffmpeg...!"
  ffmpeg_output=$( ffmpeg -y -i $local_input_filepath -vcodec libx264 -pix_fmt yuv420p -b:v 711k $aspect_ratio -acodec aac -ac 2 -b:a 128k -metadata creation_time=now $local_output_filepath 2>&1 )
  ffmpeg_return="${PIPESTATUS[0]}"
fi

if [[ "$local_input_filepath" == *mkv ]]
  then
  echo "Detected mkv file, doing ffmpeg...!"
  ffmpeg_output=$( ffmpeg -y -i $local_input_filepath -vcodec libx264 -pix_fmt yuv420p -b:v 711k $aspect_ratio -acodec aac -ac 2 -b:a 128k -metadata creation_time=now $local_output_filepath 2>&1 )
  ffmpeg_return="${PIPESTATUS[0]}"
fi

if [[ "$local_input_filepath" == *mov ]]
  then
  echo "Detected mov file, doing ffmpeg...!"
  ffmpeg_output=$( ffmpeg -y -i $local_input_filepath -vcodec libx264 -pix_fmt yuv420p -b:v 711k $aspect_ratio -acodec aac -ac 2 -b:a 128k -metadata creation_time=now $local_output_filepath 2>&1 )
  ffmpeg_return="${PIPESTATUS[0]}"
fi

if [[ "$local_input_filepath" == *dif ]]
  then
  echo "Detected dif file, doing ffmpeg...!"
  ffmpeg_output=$( ffmpeg -y -i $local_input_filepath -vcodec libx264 -pix_fmt yuv420p -b:v 711k $aspect_ratio -acodec aac -ac 2 -b:a 128k -metadata creation_time=now $local_output_filepath 2>&1 )
  ffmpeg_return="${PIPESTATUS[0]}"
fi

if [[ "$local_input_filepath" == *mxf ]]
  then
  echo "Detected mxf file, doing ffmpeg...!"
  ffmpeg_output=$( ffmpeg -y -i $local_input_filepath -vcodec libx264 -pix_fmt yuv420p -b:v 711k $aspect_ratio -acodec aac -ac 2 -b:a 128k -metadata creation_time=now $local_output_filepath 2>&1 )
  ffmpeg_return="${PIPESTATUS[0]}"
fi

if [[ "$local_input_filepath" == *m2t ]]
  then
  echo "Detected m2t file, doing ffmpeg...!"
  ffmpeg_output=$( ffmpeg -y -i $local_input_filepath -vcodec libx264 -pix_fmt yuv420p -b:v 711k $aspect_ratio -acodec aac -ac 2 -b:a 128k -metadata creation_time=now $local_output_filepath 2>&1 )
  ffmpeg_return="${PIPESTATUS[0]}"
fi

# run audio transcode
if [[ "$local_input_filepath" == *wav ]]
  then
  # mp4 extension in output filename will correctly wrap aac in mp4 container
  ffmpeg_output=$( ffmpeg -y -i $local_input_filepath -acodec aac $local_output_filepath 2>&1 )
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
  aws --endpoint-url 'http://s3-bos.wgbh.org' s3api put-object --bucket $DRTRANSCODE_OUTPUT_BUCKET --key $errorfilename --body ./$errorfilename
  # add public acl to de error txt file
  aws --endpoint-url 'http://s3-bos.wgbh.org' s3api put-object-acl --bucket $DRTRANSCODE_OUTPUT_BUCKET --key $errorfilename --acl public-read
  exit 1
fi

echo "Finished transcode, getting durations..."

oduration=$(duration $local_input_filepath)
pduration=$(duration $local_output_filepath)

# write durations and metadata to file
echo "${DRTRANSCODE_UID},${DRTRANSCODE_INPUT_BUCKET},${DRTRANSCODE_INPUT_KEY},${oduration},${pduration}" > "${workspace_folder}/${DRTRANSCODE_UID}-durations.txt"

# upload durations file to obsto (controller will pick up if applicable)
echo "Uploading durations file ${DRTRANSCODE_UID}-durations.txt"
# echo "catted $(cat ${workspace_folder}/${DRTRANSCODE_UID}-durations.txt)"
aws --endpoint-url 'http://s3-bos.wgbh.org' s3api put-object --bucket $DRTRANSCODE_OUTPUT_BUCKET --key "${DRTRANSCODE_UID}-durations.txt" --body "${workspace_folder}/${DRTRANSCODE_UID}-durations.txt"
echo "]!"


increment_retry_file
# (retry uses the same pod, because the output file will not be present, so job will just start over)



success=false
# use bc for float math
difference=$(echo "$pduration-$oduration" | bc -l)

if [[ "$local_input_filepath" == *mov ]]
  then
  echo "Checking durations for mov file, allowing  +/-1s..."
  
  echo "For mov file, found difference of ${difference}"

  if [[ $(echo "$difference>=-1" | bc -l) == 1 && $(echo "$difference<=1" | bc -l) == 1 ]]
  then
    echo "Found acceptable difference ${difference}"
    success=true
  else
    echo "mov difference was unacceptable! ${difference}"
  fi
else
  echo "Checking durations for regular file, allowing  +/-0.04s..."
  if [[  $(echo "$difference>=-0.04" | bc -l) == 1 && $(echo "$difference<=0.04" | bc -l) == 1 ]]
    then
    echo "Durations were acceptable! Difference: ${difference}"
    success=true
  fi
fi

if [[ $success == true ]]
then

  # # upload output file to s3
  echo "Uploading output file..."
  aws --endpoint-url 'http://s3-bos.wgbh.org' s3api put-object --bucket $DRTRANSCODE_OUTPUT_BUCKET --key $destination_output_key --body $local_output_filepath

  # add public acl to de file
  aws --endpoint-url 'http://s3-bos.wgbh.org' s3api put-object-acl --bucket $DRTRANSCODE_OUTPUT_BUCKET --key $destination_output_key --acl public-read

else
  echo "Oh lord! bad durations did not match $(cat "${DRTRANSCODE_UID}-durations.txt")"
  # clean up work files you curse-ed beast
  rm -rf "${workspace_folder}"

  # oh god, not again!
  # job will autoretry after reboot
fi


# bye!

