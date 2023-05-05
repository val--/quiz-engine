######################################
# Base image for common dependencies #
# between development and production #
######################################

FROM debian:bullseye-slim AS base

ENV DEBIAN_FRONTEND=noninteractive\
    PHP_CONF_DATE_TIMEZONE=UTC \
    PHP_CONF_DISPLAY_ERRORS=0 \
    PHP_CONF_DISPLAY_STARTUP_ERRORS=0 \
    PHP_CONF_ERROR_REPORTING=22527 \
    PHP_CONF_OPCACHE_VALIDATE_TIMESTAMP=0 \
    PHP_CONF_ZEND_ASSERTIONS=-1

RUN echo 'APT::Install-Recommends "0" ; APT::Install-Suggests "0" ;' > /etc/apt/apt.conf.d/01-no-recommended && \
    echo 'path-exclude=/usr/share/doc/*' > /etc/dpkg/dpkg.cfg.d/path_exclusions && \
    echo 'path-exclude=/usr/share/groff/*' >> /etc/dpkg/dpkg.cfg.d/path_exclusions && \
    echo 'path-exclude=/usr/share/info/*' >> /etc/dpkg/dpkg.cfg.d/path_exclusions && \
    echo 'path-exclude=/usr/share/linda/*' >> /etc/dpkg/dpkg.cfg.d/path_exclusions && \
    echo 'path-exclude=/usr/share/lintian/*' >> /etc/dpkg/dpkg.cfg.d/path_exclusions && \
    echo 'path-exclude=/usr/share/locale/*' >> /etc/dpkg/dpkg.cfg.d/path_exclusions && \
    echo 'path-exclude=/usr/share/man/*' >> /etc/dpkg/dpkg.cfg.d/path_exclusions && \
    apt-get update && \
    apt-get --yes install apt-transport-https ca-certificates gpg gpg-agent wget && \
    echo 'deb https://packages.sury.org/php/ bullseye main' > /etc/apt/sources.list.d/sury.list && \
    wget -O sury.gpg https://packages.sury.org/php/apt.gpg && apt-key add sury.gpg && rm sury.gpg && \
    echo 'deb [trusted=yes] https://repo.symfony.com/apt/ /' | tee /etc/apt/sources.list.d/symfony-cli.list && \
    apt-get update && \
    apt-get --yes install \
        php8.1-apcu \
        php8.1-cli \
        php8.1-curl \
        php8.1-dom \
        php8.1-fpm \
        php8.1-intl \
        php8.1-mbstring \
        php8.1-opcache \
        php8.1-pdo \
        php8.1-pgsql \
        php8.1-zip && \
    apt-get clean && \
    apt-get --yes autoremove --purge && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    mkdir -p /run/php/

COPY back/docker/php/php.ini /etc/php/8.1/cli/conf.d/99-app.ini

EXPOSE 8000

FROM base AS dev

ENV XDEBUG_ENABLED=0

RUN apt-get update && \
    apt-get --yes install \
        git \
        php8.1-xdebug \
        symfony-cli \
        unzip && \
    apt-get clean && \
    apt-get --yes autoremove --purge && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    mkdir /.symfony5 && chmod 777 /.symfony5

# Configure XDEBUG and make XDEBUG activable at container start
#COPY docker/php/xdebug.ini /etc/php/8.1/cli/conf.d/99-app-xdebug.ini

# Install composer
COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer
RUN chmod +x /usr/local/bin/composer

FROM dev AS builder

WORKDIR /srv/app

COPY . .

RUN composer install --no-dev --no-interaction

FROM base AS prod

ENV APP_ENV=prod \
    APP_DEBUG=0

WORKDIR /srv/app

COPY --from=builder --chown=www-data:www-data /srv/app/bin bin
COPY --from=builder --chown=www-data:www-data /srv/app/config config
COPY --from=builder --chown=www-data:www-data /srv/app/src src
COPY --from=builder --chown=www-data:www-data /srv/app/public public
COPY --from=builder --chown=www-data:www-data /srv/app/vendor vendor
COPY --from=builder --chown=www-data:www-data /srv/app/.env .
COPY --from=builder --chown=www-data:www-data /srv/app/composer.json .
RUN chown -R www-data:www-data /srv/app

USER www-data
RUN bin/console cache:warmup
USER root
CMD ["php-fpm", "--nodaemonize"]
