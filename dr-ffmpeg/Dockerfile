FROM ubuntu:latest

WORKDIR /root

RUN mkdir -p .aws/

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -qq -y awscli ffmpeg curl

ADD transcode.sh transcode.sh 
RUN chmod +x transcode.sh

CMD bash -c "./transcode.sh"
