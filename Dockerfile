FROM php:7-fpm-alpine

LABEL maintainer Alipeng <lipeng.yang@mobvista.com>

ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/

RUN chmod +x /usr/local/bin/install-php-extensions && sync && \
  install-php-extensions \
  soap \
  exif \
  gd \
  zip \
  intl \
  pdo_mysql \
  pcntl \
  pgsql \
  pdo_pgsql \
  opcache \
  swoole \
  imagick \
  redis \
  mongodb && \
  #somke test
  php --version
