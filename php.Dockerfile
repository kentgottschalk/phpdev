# Inspired by the official Drupal alpine image
# See: https://github.com/docker-library/drupal

# from https://www.drupal.org/docs/8/system-requirements/drupal-8-php-requirements
FROM php:7.0-fpm-alpine

# install the PHP extensions we need
# Memcahed installation: https://stackoverflow.com/a/41575677
# Soap installation: https://github.com/docker-library/php/issues/315#issuecomment-264645332
# Imagick installation: https://gist.github.com/johndatserakis/825a16a7f3cef4e8b4dbfbb1e80b9f9c
# postgresql-dev is needed for https://bugs.alpinelinux.org/issues/3642
RUN set -eux \
  && apk update \
  && apk add --no-cache --update --virtual .phpize-deps $PHPIZE_DEPS \
  && apk add --no-cache --update --virtual .build-deps \
    # This is needed for installing PECL extensions (appearently).
    $PHPIZE_DEPS \
    coreutils \
    freetype-dev \
    libjpeg-turbo-dev \
    libpng-dev \
    libzip-dev \
    postgresql-dev \
    zlib-dev \
    libmemcached-dev \
    cyrus-sasl-dev \
    libmcrypt-dev \
    libxml2-dev \
    imagemagick-dev \
    libtool \
  && docker-php-ext-configure gd \
    --with-freetype-dir=/usr/include/ \
    --with-jpeg-dir=/usr/include/ \
    --with-png-dir=/usr/include/ \
  && docker-php-ext-configure mcrypt \
  && docker-php-ext-install -j "$(nproc)" \
    gd \
    opcache \
    pdo_mysql \
    pdo_pgsql \
    zip \
    mcrypt \
    soap \
    && pecl install memcached-3.0.4 \
    && pecl install imagick-3.4.4 \
    && pecl install xdebug-2.7.2 \
    # Do not enable xdebug by default for performance reasons.
    && docker-php-ext-enable memcached imagick \
    && runDeps="$( \
    scanelf --needed --nobanner --format '%n#p' --recursive /usr/local \
      | tr ',' '\n' \
      | sort -u \
      | awk 'system("[ -e /usr/local/lib/" $1 " ]") == 0 { next } { print "so:" $1 }' \
  )" \
  && apk add --virtual .drupal-phpexts-rundeps $runDeps \
  && apk del .build-deps .phpize-deps \
  && rm -rf /usr/share/php7 \
    && rm -rf /tmp/*

# set recommended PHP.ini settings
# see https://secure.php.net/manual/en/opcache.installation.php
RUN { \
    echo 'opcache.memory_consumption=128'; \
    echo 'opcache.interned_strings_buffer=8'; \
    echo 'opcache.max_accelerated_files=4000'; \
    echo 'opcache.revalidate_freq=0'; \
    echo 'opcache.fast_shutdown=1'; \
    echo 'opcache.enable_cli=1'; \
  } > /usr/local/etc/php/conf.d/opcache-recommended.ini

# Default production configuration is optimized and recommended to use
RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

# Add own php configuration
COPY files/php/conf $PHP_INI_DIR/conf.d/

WORKDIR /var/www
