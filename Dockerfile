FROM php:alpine

RUN set -xe \
    && docker-php-ext-install pcntl \
    && docker-php-ext-install bcmath
