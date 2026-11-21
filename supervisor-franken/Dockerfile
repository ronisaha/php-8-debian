ARG PHP_VERSION=8.6.0

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
        --with github.com/dunglas/frankenphp@v1.13.6 \
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

# The latest PECL releases of apcu, igbinary, yaml and redis do not compile on
# PHP 8.6 yet, so build them from pinned upstream sources.
# TODO: switch back to plain extension names once 8.6-compatible releases are out.
RUN set -eux; \
	install-php-extensions \
        mongodb \
        pdo_pgsql \
        pdo_mysql \
        bcmath \
            krakjoe/apcu@66300e28647c16fef7672a5add532f4262b23a75 \
            gd \
            intl \
            opcache \
            zip \
            igbinary/igbinary@2b1f5d62e3037b07c2a46499ac32091cdb41fb40 \
            php/pecl-file_formats-yaml@a7a3b8680b8fbf0895fd63371a0ffc1305b1a5b8 \
            xsl \
            gettext \
            sockets \
	; \
	# the phpredis GitHub tarball lacks the bundled liblzf submodule, so link the system one
	apt-get update; \
	apt-get install -y --no-install-recommends liblzf-dev; \
	docker-php-source extract; \
	mkdir -p /usr/src/php/ext/redis; \
	curl -fsSL https://github.com/phpredis/phpredis/archive/a6ce1e60b3e81ce3b25174aa5aaefd5590dc64fd.tar.gz | tar -xz --strip-components=1 -C /usr/src/php/ext/redis; \
	docker-php-ext-configure redis --enable-redis-igbinary --enable-redis-lzf --with-liblzf; \
	docker-php-ext-install -j$(nproc) redis; \
	docker-php-source delete; \
	rm -rf /var/lib/apt/lists/*
