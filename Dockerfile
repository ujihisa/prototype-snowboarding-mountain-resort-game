FROM ruby:3.0.1

RUN \
  curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
  echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
  apt-get update -qq && \
  apt-get install -y build-essential nodejs yarn && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

ENV APP_HOME=/usr/src/app

RUN useradd -m -u 1000 rails
RUN mkdir "${APP_HOME}" && chown rails "${APP_HOME}"
USER rails

WORKDIR "${APP_HOME}"

COPY --chown=rails package.json yarn.lock ./
RUN yarn install --check-files --silent

# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1

COPY --chown=rails Gemfile Gemfile.lock ./
RUN bundle install

COPY --chown=rails . ./

ARG RAILS_ENV
ENV RAILS_ENV=${RAILS_ENV:-development}

RUN if [ "${RAILS_ENV}" = "production" ]; then\
  export SKIP_GOOGLE_CLOUD_STORAGE=1;\
  SECRET_KEY_BASE=`bin/rake secret` bin/rake assets:precompile;\
fi

EXPOSE 8080

# tmp/pids/server.pid is just for docker-compose
RUN rm -f ./tmp/pids/server.pid

CMD ["bin/rails", "server", "--binding", "0.0.0.0"]
