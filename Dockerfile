FROM ruby:3.3.5
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs
COPY . /app
WORKDIR /app
RUN bin/setup