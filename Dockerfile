FROM php:8.2-apache

# Install extension mysqli
RUN docker-php-ext-install mysqli

# Enable Apache mod_rewrite
RUN a2enmod rewrite

# FIX ERROR MPM
RUN a2dismod mpm_event
RUN a2enmod mpm_prefork

# Copy project ke Apache
COPY . /var/www/html/

EXPOSE 80
