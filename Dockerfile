FROM php:7.1-fpm-alpine

ENV REFRESHED_AT=20170913

RUN set -xe \
    && NPROC=$(grep -c ^processor /proc/cpuinfo 2>/dev/null || 1) \
    # && sed -i "s/dl-cdn.alpinelinux.org/mirrors.aliyun.com/" /etc/apk/repositories \

    # install build deps
    && apk --no-cache add --virtual .build-deps \
        libwebp-dev \
        freetype-dev \
        libpng-dev \
        libmcrypt-dev \
        libjpeg-turbo-dev \
        openssl-dev \
        imagemagick-dev \
        libltdl \
        autoconf \
        gcc \
        g++ \
        libtool \
        make \
        pcre-dev \

    # install run deps
    && apk --no-cache add --virtual .run-deps \
        libpng \
        libjpeg \
        libwebp \
        freetype \
        imagemagick \

    && docker-php-ext-configure gd \
        --with-webp-dir=/usr/include/ \
        --with-jpeg-dir=/usr/include/ \
        --with-freetype-dir=/usr/include/ \

    && pecl install mongodb && docker-php-ext-enable mongodb \
    && pecl install imagick && docker-php-ext-enable imagick \

    && docker-php-ext-install -j$NPROC opcache gd bcmath pdo_mysql mysqli \
    && apk del .build-deps
