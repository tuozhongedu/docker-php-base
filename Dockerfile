FROM php:7.1-fpm-alpine

ENV REFRESHED_AT=20170913

RUN set -xe \
    && NPROC=$(grep -c ^processor /proc/cpuinfo 2>/dev/null || 1) \
    # && sed -i "s/dl-cdn.alpinelinux.org/mirrors.aliyun.com/" /etc/apk/repositories \

    # install build deps
    && apk add --no-cache --virtual .build-deps \
        libwebp-dev \
        freetype-dev \
        libpng-dev \
        libmcrypt-dev \
        libjpeg-turbo-dev \
        autoconf \

    # install run deps
    # && apk add --no-cahce --virtual .run-deps \
        # libpng \
    && docker-php-ext-configure gd \
        --with-webp-dir=/usr/include/ \
        --with-jpeg-dir=/usr/include/ \
        --with-freetype-dir=/usr/include/ \

    && pecl install mongodb \

    && docker-php-ext-install -j$NPROC gd bcmath pdo_mysql mysqli \
    && apk del .build-deps \
    && rm /var/cache/apk/*

EXPOSE 8080:8080