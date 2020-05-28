FROM ruby:2.6.5

ENV BUNDLER_VERSION=2.1.4
ENV APP_HOME /usr/src/app

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=DontWarn apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

RUN apt-get update && apt-get install -y build-essential \
    curl nodejs yarn libpq-dev libxml2-dev libxslt1-dev

RUN mkdir -p $APP_HOME
WORKDIR $APP_HOME

RUN gem install bundler -v $BUNDLER_VERSION

ADD Gemfile $APP_HOME/
ADD Gemfile.lock $APP_HOME/

RUN bundle install

ADD . $APP_HOME

RUN bundle exec rake assets:precompile