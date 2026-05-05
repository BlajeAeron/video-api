FROM php:8.2-cli

WORKDIR /app

# install mysqli
RUN docker-php-ext-install mysqli

COPY . .

CMD php -S 0.0.0.0:8080
