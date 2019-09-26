# https://github.com/nginxinc/docker-nginx/blob/c817e28dd68b6daa33265a8cb527b1c4cd723b59/mainline/alpine/Dockerfile
FROM nginx:1.17-alpine

COPY files/web/nginx.conf /etc/nginx/

# Add logrotate (inspired by Laradock):
# https://github.com/laradock/laradock/pull/2111
RUN apk update \
  && apk upgrade \
  && apk --update add logrotate \
  && apk add --no-cache bash \
  # Create 'messages' file used from 'logrotate'
  && touch /var/log/messages 

RUN set -x ; \
  addgroup -g 82 -S www-data ; \
  adduser -u 82 -D -S -G www-data www-data && exit 0 ; exit 1

COPY files/web/logrotate /etc/logrotate.d/nginx

COPY files/web/upstream.conf /etc/nginx/conf.d

RUN rm /etc/nginx/conf.d/default.conf

COPY files/web/startup.sh /opt/startup.sh
RUN sed -i 's/\r//g' /opt/startup.sh
CMD ["/bin/bash", "/opt/startup.sh"]
