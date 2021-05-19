FROM registry.gitlab.com/notch8/docker-images/samvera:v1.1.0

RUN echo 'Extra Packages' && \
    apt-get update -qq && \
    apt-get install -y \
                       python-certbot-nginx \
                       && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    echo 'Packages Downloaded'


COPY ops/webapp-ssl.conf /etc/nginx/sites-available/webapp-ssl.conf
COPY ops/webapp.conf /etc/nginx/sites-enabled/webapp.conf
COPY ops/env.conf /etc/nginx/main.d/env.conf

RUN gem install bundler -v 2.1.4
COPY --chown=app:app Gemfile* $APP_HOME/

RUN /sbin/setuser app bash -l -c "bundle check || bundle install"

COPY  --chown=app:app . $APP_HOME

COPY ops/nginx.sh /etc/service/nginx/run
RUN chmod +x /etc/service/nginx/run
RUN rm -f /etc/service/nginx/down

RUN touch /var/log/worker.log && chmod 666 /var/log/worker.log
# RUN mkdir /etc/service/worker
# COPY ops/worker.sh /etc/service/worker/run
# RUN chmod +x /etc/service/worker/run

COPY ops/letsencrypt.sh /etc/cron.hourly/letsencrypt.sh
RUN chmod +x /etc/cron.hourly/letsencrypt.sh

RUN /sbin/setuser app bash -l -c " \
    cd /home/app/webapp && \
    DB_ADAPTER=nulldb bundle exec rake assets:precompile && \
    mv ./public/assets ./public/assets-new"

CMD ["/sbin/my_init"]
