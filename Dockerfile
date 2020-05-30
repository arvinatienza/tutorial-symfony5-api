FROM php:7-apache
LABEL maintainer="Arvin Atienza"

RUN apt-get update \
    && apt-get install -y \
      git \
      unzip \
      wget \
      zip \
    && rm -rf /var/lib/apt/lists/*

#RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    #&& php -r "if (hash_file('sha384', 'composer-setup.php') === 'e0012edf3e80b6978849f5eff0d4b4e4c79ff1609dd1e613307e16318854d24ae64f26d17af3ef0bf7cfb710ca74755a') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" \
    #&& php composer-setup.php \
    #&& php -r "unlink('composer-setup.php');"

RUN wget https://getcomposer.org/download/1.10.6/composer.phar \
    && chmod +x composer.phar \
    && mv composer.phar /usr/local/bin/composer

RUN wget https://get.symfony.com/cli/installer -O - | bash \
    && mv /root/.symfony/bin/symfony /usr/local/bin/symfony

COPY config/vhost.conf /etc/apache2/sites-available/000-default.conf
ADD . /var/www/symfony
WORKDIR /var/www/symfony

RUN composer install
RUN chown www-data:www-data . -R
