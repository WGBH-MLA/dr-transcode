# FROM ubuntu:latest
FROM ruby:2.7
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y curl vim
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl && chmod +x ./kubectl && mv ./kubectl /usr/local/bin/kubectl

WORKDIR /root
ADD app/ app/

WORKDIR /root/app/
RUN bundle install

# CMD bundle exec queue.rb