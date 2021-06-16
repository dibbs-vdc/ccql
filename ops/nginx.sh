#!/bin/bash
set -e
if [[ ! -e /var/log/nginx/error.log ]]; then
        # The Nginx log forwarder might be sleeping and waiting
        # until the error log becomes available. We restart it in
        # 1 second so that it picks up the new log file quickly.
        (sleep 1 && sv restart /etc/service/nginx-log-forwarder)
fi

if [[ -e /etc/letsencrypt/live/$DOCKER_HOST/fullchain.pem ]]; then
    cp /etc/nginx/sites-available/webapp-ssl.conf /etc/nginx/sites-enabled/webapp.conf
fi

sed -i "s/SERVER_NAME/$DOCKER_HOST/" /etc/nginx/sites-enabled/webapp.conf

if [ -z $PASSENGER_APP_ENV ]
then
    export PASSENGER_APP_ENV=development
fi

if [[ $PASSENGER_APP_ENV == "development" ]] || [[ $PASSENGER_APP_ENV == "test" ]]
then
    /sbin/setuser app /bin/bash -l -c 'cd /home/app/webapp && bundle exec rails db:test:prepare'
fi

if [[ $PASSENGER_APP_ENV == "production" ]] || [[ $PASSENGER_APP_ENV == "staging" ]]
then
    /bin/bash -l -c 'chown app:app /home/app/webapp/tmp' # mounted volume may have wrong permissions
    /bin/bash -l -c 'chown app:app /home/app/webapp/public/assets' # mounted volume may have wrong permissions
    /sbin/setuser app /bin/bash -l -c 'cd /home/app/webapp && bundle exec rake db:migrate'
    # copy new assets over to volume
    if [ -d /home/app/webapp/public/assets-new ]; then
        /sbin/setuser app /bin/bash -l -c 'cd /home/app/webapp && rsync -a public/assets-new/ public/assets/'
    fi
fi

/sbin/setuser app /bin/bash -l -c 'mkdir -p /home/app/webapp/public/globus'
/sbin/setuser app /bin/bash -l -c 'mkdir -p /home/app/webapp/tmp/import'

exec /usr/sbin/nginx
