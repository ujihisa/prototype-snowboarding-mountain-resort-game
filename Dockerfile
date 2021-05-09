FROM ruby:3.0.1

RUN \
  curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
  echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
  apt-get update -qq && \
  apt-get install -y build-essential nodejs yarn && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

WORKDIR /usr/src/app

RUN \
  export GCSFUSE_REPO=gcsfuse-buster &&\
  echo "deb http://packages.cloud.google.com/apt $GCSFUSE_REPO main" | tee /etc/apt/sources.list.d/gcsfuse.list &&\
  curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -  &&\
  apt-get update -qq &&\
  apt-get install -y gcsfuse &&\
  apt-get clean &&\
  rm -rf /var/lib/apt/lists/*

COPY package.json yarn.lock $APP_HOME/
RUN yarn install --check-files --silent

# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

RUN env SKIP_GOOGLE_CLOUD_STORAGE=1 bin/rake secret > /tmp/secret
RUN env SKIP_GOOGLE_CLOUD_STORAGE=1 SECRET_KEY_BASE=`cat /tmp/secret` bin/rake assets:precompile

EXPOSE 8080

CMD ["bash", "-eu", "./start_app.sh"]
