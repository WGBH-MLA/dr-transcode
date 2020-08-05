# FROM ubuntu:latest
FROM ruby:2.7

# groff is a dependency that screws up awscli install without 'failing' install
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install --force-yes  -y1 groff awscli curl cron vim
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl && chmod +x ./kubectl && mv ./kubectl /usr/local/bin/kubectl

WORKDIR /root
COPY queue-cron /etc/cron.d/queue-cron
RUN chmod 0644 /etc/cron.d/queue-cron
RUN crontab /etc/cron.d/queue-cron
RUN touch /var/log/queue-cron.log

ADD app/ app/
WORKDIR /root/app/
RUN bundle install

CMD cron && tail -f /var/log/queue-cron.log
