FROM php:8.2-apache-bullseye

# Install dependencies
RUN apt-get update && apt-get install -y \
    gnupg2 \
    curl \
    apt-transport-https \
    software-properties-common \
    unzip \
    zip \
    git \
    libzip-dev \
    libpng-dev \
    libjpeg-dev \
    libwebp-dev \
    libfreetype6-dev \
    unixodbc \
    unixodbc-dev \
    lsb-release

# Tambah repo Microsoft (SQL Server driver)
RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - && \
    curl https://packages.microsoft.com/config/debian/11/prod.list > /etc/apt/sources.list.d/mssql-release.list

# Install Microsoft SQL Server ODBC driver
RUN apt-get update && ACCEPT_EULA=Y apt-get install -y msodbcsql17

# Install PHP extensions
RUN pecl install pdo_sqlsrv sqlsrv && \
    docker-php-ext-enable pdo_sqlsrv sqlsrv && \
    docker-php-ext-install zip gd && \
    a2enmod rewrite

# Use production php.ini
RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

WORKDIR /var/www/html

COPY ./apache/default.conf /etc/apache2/sites-enabled/000-default.conf
