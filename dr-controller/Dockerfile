FROM ruby:2.7.3

# groff is a dependency that screws up awscli install without 'failing' install
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install --force-yes  -y1 groff awscli curl cron vim
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl && chmod +x ./kubectl && mv ./kubectl /usr/local/bin/kubectl

WORKDIR /root

# COPY queue-cron /root/queue-cron
# RUN chmod 0644 /root/queue-cron
# RUN crontab /root/queue-cron

COPY queue-cron /var/spool/cron/crontabs/root
RUN crontab /var/spool/cron/crontabs/root
RUN touch /var/log/queue-cron.log

ADD app/ app/
WORKDIR /root/app/
RUN chmod +x /root/app/check_number_pods.sh
RUN gem install bundler
RUN bundle install

# bundler recommends using these if you havin trubb
# ENV GEM_HOME="/usr/local/bundle"
# ENV PATH $GEM_HOME/bin:$GEM_HOME/gems/bin:$PATH
CMD /usr/sbin/cron -f && tail -f /var/log/queue-cron.log
