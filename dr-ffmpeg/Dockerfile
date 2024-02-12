FROM ubuntu:latest

WORKDIR /root

RUN mkdir -p .aws/

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install --force-yes  -y1 awscli ffmpeg

COPY transcode.sh transcode.sh 
RUN chmod +x transcode.sh

CMD bash -c "./transcode.sh"
