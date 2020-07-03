FROM ruby:2.6

ENV BUNDLER_VERSION=2.1.4
ENV APP_HOME /usr/src/app

RUN apt-get update && apt-get install -y build-essential \
    curl nodejs libpq-dev libxml2-dev libxslt1-dev graphviz

RUN mkdir -p $APP_HOME
WORKDIR $APP_HOME

RUN gem install bundler -v $BUNDLER_VERSION

ADD Gemfile $APP_HOME/
ADD Gemfile.lock $APP_HOME/

RUN bundle install

ADD . $APP_HOME

RUN bundle exec rake assets:precompile