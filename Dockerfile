FROM ruby:2.5.1
RUN apt-get update -qq && \
    apt-get install -y build-essential libpq-dev nodejs vim libreoffice imagemagick unzip ghostscript && \
    rm -rf /var/lib/apt/lists/*
RUN mkdir -p /opt/fits && \
    curl -fSL -o /opt/fits/fits-latest.zip https://github.com/harvard-lts/fits/releases/download/1.4.0/fits-latest.zip && \
    cd /opt/fits && unzip fits-latest.zip && chmod +X /opt/fits/fits.sh

RUN mkdir /data
WORKDIR /data
ADD Gemfile /data/Gemfile
ADD Gemfile.lock /data/Gemfile.lock
ENV BUNDLE_JOBS=4
RUN bundle install
ADD . /data
#RUN  cd /data && NODE_ENV=production DB_ADAPTER=nulldb bundle exec rake assets:clobber assets:precompile
EXPOSE 3000

CMD ["bin/rails", "console"]
