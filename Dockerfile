FROM dpiquet/php5.5-apache2

# Install dependencies

RUN set -xe \
    # Install PHP dependencies
    && apt-get update && apt-get install -y git subversion openssh-client coreutils unzip postgresql-client \
    && apt-get install -y autoconf gcc g++ libpq-dev binutils-gold libgcc1 linux-headers-amd64 make python libmcrypt-dev libpng-dev libjpeg-dev libc-dev libfreetype6-dev libmcrypt-dev libicu-dev \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \

    # Install Xdebug
    && pecl install xdebug \
    && echo 'zend_extension=/usr/local/lib/php/extensions/no-debug-non-zts-20131226/xdebug.so' > /usr/local/etc/php/conf.d/xdebug.ini \

    # Configuration PHP
    && docker-php-ext-install -j$(nproc) iconv mbstring mcrypt intl pdo_pgsql gd zip bcmath \
    && docker-php-source delete \
    && echo "Installing composer" \

    # Enable httpd mod_rewrite
    && a2enmod rewrite \

    # Suppression des dépendances de build
    && apt-get remove -y autoconf gcc g++ libpq-dev linux-headers-amd64 make libmcrypt-dev libicu-dev \
    && apt-get clean
