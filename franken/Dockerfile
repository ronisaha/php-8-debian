ARG PHP_VERSION=8.3.13
FROM dunglas/frankenphp:1-php${PHP_VERSION}-bookworm

LABEL org.opencontainers.image.authors="Roni Kumar Saha <roni.csed@gmail.com>"

# persistent / runtime deps
# hadolint ignore=DL3008
RUN apt-get update && apt-get install -y --no-install-recommends \
	acl \
	file \
	gettext \
	&& rm -rf /var/lib/apt/lists/*

RUN set -eux; \
	install-php-extensions \
		redis \
        amqp \
        mongodb \
        pdo_pgsql \
        pdo_mysql \
        bcmath \
            apcu \
            gd \
            intl \
            opcache \
            zip \
            igbinary \
            yaml \
            xsl \
            gettext \
            opcache \
            sockets \
	;
