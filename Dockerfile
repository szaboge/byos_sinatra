FROM ruby:slim

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    build-essential \
    ruby-bundler \
    git \
    sqlite3 \
    pkg-config \
    firefox-esr \
    imagemagick \
    libpq-dev && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY Gemfile Gemfile.lock ./
RUN bundle install
COPY . .
EXPOSE 4567
CMD ["bundle", "exec", "ruby", "app.rb", "-o", "0.0.0.0"]
