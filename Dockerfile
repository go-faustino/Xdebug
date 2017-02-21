FROM php:7.1.2-apache

# Setup the Xdebug version to install
ENV XDEBUG_VERSION 2.5.0
ENV XDEBUG_SHA1 0d31602a6ee2ba6d2e18a6db79bdb9a2a706bcd9

COPY /php/php.ini /usr/local/etc/php/
RUN apt-get update && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng12-dev \
        libxml2-dev \
        apache2-dev \
        libssl-dev \
        libcurl4-gnutls-dev \
        libedit-dev \
        librecode-dev \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-configure calendar --enable-calendar \
    && docker-php-ext-install calendar \
    && docker-php-ext-configure pdo_mysql --with-pdo-mysql \
    && docker-php-ext-install pdo_mysql \
    && docker-php-ext-configure readline --with-readline \
    && docker-php-ext-install readline \
    && docker-php-ext-configure recode --with-recode \
    && docker-php-ext-install recode \
    && docker-php-ext-configure pdo_mysql --with-pdo-mysql \
    && docker-php-ext-install pdo_mysql 
RUN a2enmod rewrite

# Install Xdebug
RUN set -x \
	&& curl -SL "http://www.xdebug.org/files/xdebug-$XDEBUG_VERSION.tgz" -o xdebug.tgz \
	&& echo $XDEBUG_SHA1 xdebug.tgz | sha1sum -c - \
	&& mkdir -p /usr/src/xdebug \
	&& tar -xf xdebug.tgz -C /usr/src/xdebug --strip-components=1 \
	&& rm xdebug.* \
	&& cd /usr/src/xdebug \
	&& phpize \
	&& ./configure \
	&& make -j"$(nproc)" \
	&& make install \
	&& make clean

COPY ext-xdebug.ini /usr/local/etc/php/conf.d/