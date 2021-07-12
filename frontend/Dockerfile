FROM node:14.17.1

RUN apt-get update && apt-get install -y \
    vim \
 && rm -rf /var/lib/apt/lists/*

ENV APP_ROOT /app/frontend
RUN mkdir -p /app/frontend
WORKDIR $APP_ROOT

RUN npm install -g create-nuxt-app
