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
[ -z "$DRTRANSCODE_OUTPUT_BUCKET" ] && [ -z "$DRTRANSCODE_INPUT_BUCKET" ] && [ -z "$DRTRANSCODE_INPUT_KEY" ] && [ -z "$DRTRANSCODE_PRESERVE_AUDIO_CHANNEL"] && echo "Missing DRTRANSCODE env variables, bye bye!" && exit 1

echo "Building expected output filename..."
filename=$(basename -- "$DRTRANSCODE_INPUT_KEY")
filename_no_ext=$(basename -- "$DRTRANSCODE_INPUT_KEY" .dv .mkv .mov .wav)
local_input_filepath=/root/"$filename"
mp4filename="$filename_no_ext".mp4
local_output_filepath=/root/"split-$mp4filename"

keypath=$(dirname "$DRTRANSCODE_INPUT_KEY")
# s3:streaming-proxies//< folder named after input bucket name>/<full input key path from input bucket>/< input filename but with mp4 extension >
destination_output_key="$DRTRANSCODE_INPUT_BUCKET"/"$keypath"/"$mp4filename"


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

echo "Downloading input file..."
# in this worker, input file is an existing mp4 proxy file
aws --endpoint-url 'http://s3-bos.wgbh.org' s3api get-object --bucket $DRTRANSCODE_INPUT_BUCKET --key $DRTRANSCODE_INPUT_KEY $local_input_filepath


# run video transcode
# mp4 extension in output filename will correctly wrap aac in mp4 container
# AUDIOSPLIT param is L or R, below specifies mono output, made from 'FL' or 'FR'
# create output as "split-#{inputfilename}"
ffmpeg_output=$( ffmpeg -i $local_input_filepath -af "pan=mono|c0=F$DRTRANSCODE_PRESERVE_AUDIO_CHANNEL" -vcodec libx264 -pix_fmt yuv420p -b:v 711k -s 640:360 -acodec aac -ac 1 $local_output_filepath 2>&1 )

ffmpeg_return="${PIPESTATUS[0]}"

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

# # upload output file back to s3, overwriting input proxy (per rebecca)
aws --endpoint-url 'http://s3-bos.wgbh.org' s3api put-object --bucket $DRTRANSCODE_BUCKET --key $DRTRANSCODE_INPUT_KEY --body $local_output_filepath
# # write done file to s3

# we did it boys!
echo "Great Job! $DRTRANSCODE_INPUT_KEY" > ./donefile
aws --endpoint-url 'http://s3-bos.wgbh.org' s3api put-object --bucket $DRTRANSCODE_BUCKET --key dr-transcode-successes/success-$DRTRANSCODE_UID.txt --body ./donefile

# add public acl to de file
aws --endpoint-url 'http://s3-bos.wgbh.org' s3api put-object-acl --bucket $DRTRANSCODE_BUCKET --key $DRTRANSCODE_INPUT_KEY --acl public-read
