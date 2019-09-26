FROM node:6.14-alpine

RUN npm install -g bower gulp node-sass

RUN mkdir /app

WORKDIR /app
VOLUME /app

ENTRYPOINT ["gulp"]
