function done_file_exists {
  donefilename="dr-transcode-successes/success-${DRTRANSCODE_UID}.txt"
  aws --endpoint-url 'http://s3-bos.wgbh.org' s3api head-object --bucket $DRTRANSCODE_BUCKET --key $donefilename &> /dev/null
}

function error_file_exists {
  errorfilename="dr-transcode-errors/error-${DRTRANSCODE_UID}.txt"
  aws --endpoint-url 'http://s3-bos.wgbh.org' s3api head-object --bucket $DRTRANSCODE_BUCKET --key $errorfilename &> /dev/null
}

# download input file
cd /root

# exit
[ -z "$DRTRANSCODE_UID" ] && [ -z "$DRTRANSCODE_BUCKET" ] && [ -z "$DRTRANSCODE_INPUT_KEY" ] && [ -z "$DRTRANSCODE_INPUT_FILENAME" ] && [ -z "$DRTRANSCODE_AUDIOSPLIT_CHANNEL"] && echo "Missing DRTRANSCODE env variables, bye bye!" && exit 1

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
aws --endpoint-url 'http://s3-bos.wgbh.org' s3api get-object --bucket $DRTRANSCODE_BUCKET --key $DRTRANSCODE_INPUT_KEY $DRTRANSCODE_INPUT_FILENAME


# run video transcode
# mp4 extension in output filename will correctly wrap aac in mp4 container
# AUDIOSPLIT param is L or R, below specifies mono output, made from 'FL' or 'FR'
# create output as "split-#{inputfilename}"
ffmpeg_output=$( ffmpeg -i $DRTRANSCODE_INPUT_FILENAME -af "pan=mono|c0=F$DRTRANSCODE_AUDIOSPLIT_CHANNEL" -vcodec libx264 -pix_fmt yuv420p -b:v 711k -s 640:360 -acodec aac -ac 1 split-$DRTRANSCODE_INPUT_FILENAME 2>&1 )

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
aws --endpoint-url 'http://s3-bos.wgbh.org' s3api put-object --bucket $DRTRANSCODE_BUCKET --key $DRTRANSCODE_INPUT_KEY --body ./split-$DRTRANSCODE_INPUT_FILENAME
# # write done file to s3
aws --endpoint-url 'http://s3-bos.wgbh.org' s3api put-object --bucket $DRTRANSCODE_BUCKET --key dr-transcode-successes/success-$DRTRANSCODE_UID.txt --body "great job"

# add public acl to de file
aws --endpoint-url 'http://s3-bos.wgbh.org' s3api put-object-acl --bucket $DRTRANSCODE_BUCKET --key $DRTRANSCODE_INPUT_KEY --acl public-read
