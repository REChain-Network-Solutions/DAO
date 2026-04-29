# PHP image
FROM php:8.3-apache

# enable required packages and gd lib
RUN apt-get update && apt-get install -y \
    libwebp-dev libxpm-dev zlib1g-dev \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    libzip-dev \
    unzip \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd zip mysqli \
    && docker-php-ext-enable mysqli zip

# enable mysqli
RUN docker-php-ext-install mysqli && docker-php-ext-enable mysqli

# set working directory
WORKDIR /var/www/html/sngine

# copy project files
COPY . .

# set server name >> localhost
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf

# enable apache rewrite mod
RUN a2enmod rewrite

# Configure Apache to trust proxy headers
RUN echo "RemoteIPHeader X-Forwarded-For" >> /etc/apache2/apache2.conf && \
    echo "RemoteIPInternalProxy 172.16.0.0/12" >> /etc/apache2/apache2.conf

# restart server
RUN service apache2 restart

# listen to port 80
EXPOSE 80

# run apache foreground
CMD ["apache2-foreground"]