# Use official PHP 8.0 with Apache image
FROM php:8.0-apache

# Install required PHP extensions for MediaWiki
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libmcrypt-dev \
    libxml2-dev \
    libonig-dev && \
    docker-php-ext-configure gd --with-freetype --with-jpeg && \
    docker-php-ext-install gd mysqli xml mbstring

# Enable Apache rewrite module
RUN a2enmod rewrite

# Set the working directory to /var/www/html
WORKDIR /var/www/html

# Copy all the MediaWiki files into the container
COPY . .

# Install Composer for PHP dependency management
RUN curl -sS https://getcomposer.org/installer | php
RUN mv composer.phar /usr/local/bin/composer

# Install PHP dependencies via Composer (MediaWiki dependencies)
RUN composer install

# Expose Apache port
EXPOSE 80

# Run Apache in the foreground
CMD ["apache2-foreground"]
