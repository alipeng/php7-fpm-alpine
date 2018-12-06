FROM php:fpm-alpine

LABEL maintainer Alipeng <lipeng.yang@mobvista.com>

RUN apk --update --virtual build-deps add \
        autoconf \
        make \
        gcc \
        g++ \
        libtool \
        curl-dev \
	icu-dev \
        freetype-dev \
        pcre-dev \
        libjpeg-turbo-dev \
        libpng-dev \
        libxml2-dev && \
    apk add \
    	  icu \
        libintl \
        freetype \
        libintl \
        libjpeg-turbo \
        libpng \
        libltdl \
        libxml2 && \
    docker-php-ext-configure gd \
        --with-gd \
        --with-freetype-dir=/usr/include/ \
        --with-png-dir=/usr/include/ \
        --with-jpeg-dir=/usr/include/ && \
    docker-php-ext-configure bcmath && \
    docker-php-ext-install \
        soap \
        bcmath \
        exif \
        gd \
        zip \
        curl \
        iconv \
        intl \
        mbstring \
        pdo_mysql \
        opcache && \
        pecl channel-update pecl.php.net && \
    printf "\n" | pecl install -o -f \
        redis \
	mongodb \
        rm -rf /tmp/pear && \
    docker-php-ext-enable \
        redis &&\
    apk del \
        build-deps

WORKDIR /var/www

CMD ["php-fpm"]

EXPOSE 9000
