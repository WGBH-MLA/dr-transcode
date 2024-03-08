function done_file_exists {
  donefilename="dr-transcode-successes/success-${DRTRANSCODE_UID}.txt"
  aws --endpoint-url 'http://s3-bos.wgbh.org' s3api head-object --bucket $DRTRANSCODE_OUTPUT_BUCKET --key $donefilename &> /dev/null
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
  [ -z "$DRTRANSCODE_OUTPUT_BUCKET" ] && [ -z "$DRTRANSCODE_INPUT_BUCKET" ] && [ -z "$DRTRANSCODE_INPUT_KEY" ] && [ -z "$DRTRANSCODE_PRESERVE_AUDIO_CHANNEL" ] && echo "Missing DRTRANSCODE env variables, bye bye!" && exit 1

# download input file
workspace_folder=/workspace/"$DRTRANSCODE_UID"

echo "Building expected output filename..."
filename=$(basename -- "$DRTRANSCODE_INPUT_KEY")
local_input_filepath="$workspace_folder"/"$filename"

# needs different filename than input file so no overwrite
output_filename=split-"$filename"
echo "mp4 filename will b ${output_filename}"
local_output_filepath=$workspace_folder/"$output_filename"

keypath=$(dirname "$DRTRANSCODE_INPUT_KEY")
# s3:streaming-proxies//< folder named after input bucket name>/<full input key path from input bucket>/< input filename but with mp4 extension >
destination_output_key="$DRTRANSCODE_INPUT_BUCKET"/"$keypath"/"$filename"


# need to get nonzero code from this in order to proceed
if done_file_exists;
  then
    echo "Done file already exists, I've no purpose in this world... Goodbye!"
    exit 0
fi
if error_file_exists;
  then
    echo "Error file found, I should fail this job... Bye!"
    exit 0
fi

mkdir -p $workspace_folder
cd $workspace_folder


echo "Downloading input file to $local_input_filepath..."
# redirect stderr to this var
download_output=$(aws --endpoint-url 'http://s3-bos.wgbh.org' s3api get-object --bucket $DRTRANSCODE_INPUT_BUCKET --key $DRTRANSCODE_INPUT_KEY $local_input_filepath 2>&1)

echo "Download output is $download_output"
if [[ $download_output == *"read, but total bytes expected is"* ]]
then
  # if we got the bad thing, say NO
  echo "Did not receive the whole file from S3, increment retry file, delete, and try again!!"
  rm -rf "$workspace_folder"
  increment_retry_file
  exit 1
fi

# run video transcode
# mp4 extension in output filename will correctly wrap aac in mp4 container
# AUDIOSPLIT param is L or R, below specifies mono output, made from 'FL' or 'FR'
# create output as "split-#{inputfilename}"

echo "i even got to here!"
ffmpeg_output=$( ffmpeg -i $local_input_filepath -af "pan=mono|c0=F$DRTRANSCODE_PRESERVE_AUDIO_CHANNEL" -vcodec libx264 -pix_fmt yuv420p -b:v 711k -s 640:360 -acodec aac -ac 1 $local_output_filepath 2>&1 )
echo "but here??? $ffmpeg_output"
ffmpeg_return="${PIPESTATUS[0]}"

echo "ffmpeg output..."
echo "$ffmpeg_output"

if [ "$ffmpeg_return" -ne "0" ]
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

echo "Checking durations for regular file, allowing  +/-0.04s..."
if [[  $(echo "$difference>=-0.04" | bc -l) == 1 && $(echo "$difference<=0.04" | bc -l) == 1 ]]
  then
  echo "Durations were acceptable! Difference: ${difference}"
  success=true
fi

if [[ $success == true ]]
then

  echo "Uploading output file..."
  # # upload output file back to s3, overwriting input proxy (per rebecca)
  aws --endpoint-url 'http://s3-bos.wgbh.org' s3api put-object --bucket $DRTRANSCODE_OUTPUT_BUCKET --key $DRTRANSCODE_INPUT_KEY --body $local_output_filepath
  # # write done file to s3

  # we did it boys!
  echo "Job succeeded yay!"
  echo "Great Job! $DRTRANSCODE_INPUT_KEY" > ./donefile
  # put donefile into stremaing-proxies
  aws --endpoint-url 'http://s3-bos.wgbh.org' s3api put-object --bucket $DRTRANSCODE_OUTPUT_BUCKET --key dr-transcode-successes/success-$DRTRANSCODE_UID.txt --body ./donefile

  # add public acl to de file
  aws --endpoint-url 'http://s3-bos.wgbh.org' s3api put-object-acl --bucket $DRTRANSCODE_INPUT_BUCKET --key $DRTRANSCODE_INPUT_KEY --acl public-read

else
  echo "Oh lord! bad durations did not match $(cat "${DRTRANSCODE_UID}-durations.txt")"
  # clean up work files you curse-ed beast
  rm -rf "${workspace_folder}"

  # oh god, not again!
  # job will autoretry after reboot
fi

