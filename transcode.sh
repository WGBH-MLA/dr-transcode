# download input file
cd /root
aws s3api get-object --bucket $DRTRANSCODE_BUCKET --key $DRTRANSCODE_INPUT_KEY $DRTRANSCODE_INPUT_FILENAME

# cat /root/.aws/credentials
# aws s3api list-objects --bucket neh-digi-test

# test for file extension to know which command to run


# run video transcode
ffmpeg -i $DRTRANSCODE_INPUT_FILENAME -vcodec libx264 -pix_fmt yuv420p -b:v 711k -s 480:360 -acodec aac -ac 2 -b:a 128k -metadata creation_time=now $DRTRANSCODE_OUTPUT_FILENAME


# ffmpeg -i $DRTRANSCODE_INPUT_FILENAME -vcodec libx264 -pix_fmt yuv420p -b:v 711k -s 480:360 -acodec aac -ac 2 -b:a 128k -metadata creation_time=now $DRTRANSCODE_OUTPUT_FILENAME

# # upload output file to s3
aws s3api put-object --bucket $DRTRANSCODE_BUCKET --key $DRTRANSCODE_OUTPUT_KEY --body ./$DRTRANSCODE_OUTPUT_FILENAME


