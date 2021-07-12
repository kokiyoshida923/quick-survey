FROM ruby:2.7.3

RUN apt-get update && apt-get install -y \
    vim \
    nodejs \
 && rm -rf /var/lib/apt/lists/*

ENV APP_ROOT /app/backend
RUN mkdir -p /app/backend
WORKDIR $APP_ROOT

COPY Gemfile $APP_ROOT/Gemfile
COPY Gemfile.lock $APP_ROOT/Gemfile.lock
RUN bundle install
COPY . $APP_ROOT
