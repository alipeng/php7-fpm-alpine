FROM php:fpm-alpine

LABEL maintainer Alipeng <lipeng.yang@mobvista.com>

RUN apk add --no-cache --virtual .build-deps \
      $PHPIZE_DEPS \
      libtool \
      icu-dev \
      curl-dev \
      freetype-dev \
      imagemagick-dev \
      pcre-dev \
      postgresql-dev \
      libjpeg-turbo-dev \
      libpng-dev \
      libzip-dev \
      libxml2-dev; \
    docker-php-ext-configure gd \
      --enable-gd \
      --with-freetype \
      --with-jpeg \
      --with-webp \
      --with-freetype \
      --enable-gd-native-ttf \
      bcmath; \
    docker-php-ext-install  -j "$(nproc)" \
        soap \
        bcmath \
        exif \
        gd \
        zip \
        intl \
        pdo_mysql \
        tokenizer \
        xml \
        pcntl \
        pgsql \
        pdo_pgsql \
        opcache && \
        pecl channel-update pecl.php.net; \
    printf "\n" | pecl install -o -f \
        swoole \
        redis; \
    docker-php-ext-enable \
        swoole \
        redis;\
    docker-php-source delete; \
    runDeps="$( \
      scanelf --needed --nobanner --format '%n#p' --recursive /usr/local \
        | tr ',' '\n' \
        | sort -u \
        | awk 'system("[ -e /usr/local/lib/" $1 " ]") == 0 { next } { print "so:" $1 }' \
    )"; \
	  apk add --no-cache $runDeps; \
	  apk del --no-network .build-deps; \
    rm -rf /tmp/pear /var/cache/apk/* ~/.pearrc

WORKDIR /var/www

CMD ["php-fpm"]

EXPOSE 9000
