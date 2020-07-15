# FROM jrottenberg/ffmpeg
# CMD dont specify a run command here, 'docker run...' args will pass through to base image
FROM ubuntu:latest

WORKDIR /root
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y awscli ffmpeg

# for production, leave this out and place by hand
ADD aws_credentials /root/.aws/credentials

ADD transcode.sh transcode.sh 
RUN chmod +x transcode.sh

CMD ./transcode.sh
