FROM ruby:3.3-alpine

WORKDIR /app

# Install dependencies needed for building gems and running the app
RUN apk add --no-cache build-base bash

COPY Gemfile Gemfile.lock ./

RUN bundle install

COPY . .

RUN chmod +x bin/mastermind

# Can be overridden: docker run -it ruby-mastermind bundle exec rspec
CMD ["bundle", "exec", "bin/mastermind"]
