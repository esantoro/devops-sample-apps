FROM php:8.2-apache

ENV APP_ENV=prod

WORKDIR /var/www/html

RUN mkdir /var/www/html/api
RUN ln -s  /var/www/html /var/www/html/api/v1


COPY index.php /var/www/html/index.php
COPY config.prod /var/www/html/config
