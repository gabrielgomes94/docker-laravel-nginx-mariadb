# Set master image
FROM php:7.2-fpm-alpine

USER root

# Copy composer.lock and composer.json
COPY composer.lock composer.json /var/www/

COPY database /var/www/database

# Set working directory
WORKDIR /var/www

# Copy existing application
COPY . /var/www

# Install Additional dependencies
RUN apk update && apk add --no-cache \
    bash \
    build-base shadow vim curl \
    php7 \
    php7-fpm \
    php7-common \
    php7-pdo \
    php7-pdo_mysql \
    php7-mysqli \
    php7-mcrypt \
    php7-mbstring \
    php7-xml \
    php7-openssl \
    php7-json \
    php7-phar \
    php7-zip \
    php7-gd \
    php7-dom \
    php7-session \
    php7-zlib \
    libpng-dev \
    php-gd \
    php7-intl \
    php7-xsl \
    nano

# Add and Enable PHP-PDO Extenstions
RUN docker-php-ext-install pdo pdo_mysql
RUN docker-php-ext-enable pdo_mysql

RUN docker-php-ext-install gd
RUN docker-php-ext-install zip

# Install PHP Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Remove Cache
RUN rm -rf /var/cache/apk/*

# Add UID '1000' to www-data
RUN usermod -u 1000 www-data

# COPY --chown=www-data:www-data . /var/www/html

# RUN chown -R www-data:www-data \
#         /var/www/storage \
#         /var/www/bootstrap/cache

RUN chown -R www-data:www-data /var/www

RUN chmod -R 755 /var/www/storage

# Change current user to www
USER www-data:www-data

# Expose port 9000 and start php-fpm server
EXPOSE 9000
CMD ["php-fpm"]

