ARG PHP_VERSION=8.4.13

FROM dunglas/frankenphp:1-builder-php${PHP_VERSION}-bookworm AS builder

COPY --from=caddy:builder /usr/bin/xcaddy /usr/bin/xcaddy

# CGO must be enabled to build FrankenPHP
RUN CGO_ENABLED=1 \
    XCADDY_SETCAP=1 \
    XCADDY_GO_BUILD_FLAGS="-ldflags='-w -s' -tags=nobadger,nomysql,nopgx" \
    CGO_CFLAGS=$(php-config --includes) \
    CGO_LDFLAGS="$(php-config --ldflags) $(php-config --libs)" \
    xcaddy build \
        --output /usr/local/bin/frankenphp \
        --with github.com/dunglas/frankenphp=./ \
        --with github.com/dunglas/frankenphp/caddy=./caddy/ \
        --with github.com/dunglas/caddy-cbrotli \
        --with github.com/dunglas/mercure/caddy \
        --with github.com/baldinof/caddy-supervisor
        # Add extra Caddy modules here


FROM dunglas/frankenphp:1-php${PHP_VERSION}-bookworm

LABEL org.opencontainers.image.authors="Roni Kumar Saha <roni.csed@gmail.com>"

COPY --from=builder /usr/local/bin/frankenphp /usr/local/bin/frankenphp

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
