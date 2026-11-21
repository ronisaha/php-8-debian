ARG PHP_VERSION=8.6.0
FROM php:${PHP_VERSION}-fpm-bookworm

LABEL org.opencontainers.image.authors="Roni Kumar Saha <roni.csed@gmail.com>"

ENV LD_LIBRARY_PATH=/usr/lib/instantclient

#install Exetentions and dependencies
RUN set -eux; \
	\
	apt-get update && apt-get -y upgrade; \
	apt-get install -y libaio1 wget unzip \
		libicu-dev \
        libzip-dev \
        libyaml-dev \
        gettext graphviz \
        libmagickwand-dev \
        librabbitmq-dev \
        liblzf-dev \
        libpq-dev  \
        imagemagick \
        libxslt1-dev \
        libjpeg62-turbo \
        libpng16-16 \
    ; \
	\
	curl -L https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions > /usr/local/bin/install-php-extensions \
  ; \
  chmod +x /usr/local/bin/install-php-extensions ; \
  install-php-extensions mongodb; \
  # PHP 8.6 ships without PECL and the latest PECL releases of these extensions
  # do not compile on 8.6 yet, so build them from pinned upstream sources.
  # TODO: switch back to install-php-extensions once 8.6-compatible releases are out.
  docker-php-source extract; \
  fetch_ext() { mkdir -p /usr/src/php/ext/$1; curl -fsSL $2 | tar -xz --strip-components=1 -C /usr/src/php/ext/$1; }; \
  fetch_ext apcu https://github.com/krakjoe/apcu/archive/66300e28647c16fef7672a5add532f4262b23a75.tar.gz; \
  fetch_ext yaml https://github.com/php/pecl-file_formats-yaml/archive/a7a3b8680b8fbf0895fd63371a0ffc1305b1a5b8.tar.gz; \
  fetch_ext igbinary https://github.com/igbinary/igbinary/archive/2b1f5d62e3037b07c2a46499ac32091cdb41fb40.tar.gz; \
  fetch_ext redis https://github.com/phpredis/phpredis/archive/a6ce1e60b3e81ce3b25174aa5aaefd5590dc64fd.tar.gz; \
  fetch_ext imagick https://github.com/Imagick/imagick/archive/55ed2e9fda264395636a2e27e51f31673f5566ab.tar.gz; \
  # amqp has no 8.6 fix upstream yet (php-amqp/php-amqp#619): XtOffsetOf was removed in 8.6
  fetch_ext amqp https://pecl.php.net/get/amqp-2.2.0.tgz; \
  sed -i 's/XtOffsetOf/offsetof/g' /usr/src/php/ext/amqp/*.c /usr/src/php/ext/amqp/*.h; \
  docker-php-ext-install -j$(nproc) apcu yaml igbinary imagick amqp; \
  docker-php-ext-configure redis --enable-redis-igbinary --enable-redis-lzf --with-liblzf; \
  docker-php-ext-install -j$(nproc) redis; \
  docker-php-ext-install -j$(nproc) iconv; \
  docker-php-ext-configure intl; \
  docker-php-ext-install -j$(nproc) intl; \
  docker-php-ext-install -j$(nproc) \
        exif \
        bcmath \
        xsl \
        gettext \
        pdo \
        pdo_mysql \
        pdo_pgsql \
        pgsql \
        soap \
        zip \
        gd \
        sockets; \
	cd /tmp; \
    case "$(dpkg --print-architecture)" in \
        amd64) oracle_arch=linuxx64 ;; \
        arm64) oracle_arch=linux-arm64 ;; \
        *) echo 'Unsupported Oracle Instant Client architecture' >&2; exit 1 ;; \
    esac; \
	wget -O instantclient-basiclite.zip "https://download.oracle.com/otn_software/linux/instantclient/instantclient-basiclite-${oracle_arch}.zip" ; \
	wget -O instantclient-sdk.zip "https://download.oracle.com/otn_software/linux/instantclient/instantclient-sdk-${oracle_arch}.zip" \
    ;\
    unzip instantclient-basiclite.zip ; \
    unzip -o instantclient-sdk.zip ;\
    rm -f instantclient-basiclite.zip; \
    rm -f instantclient-sdk.zip; \
    mv instantclient*/ /usr/lib/instantclient; \
    cd /usr/lib/instantclient ; \
    rm -f *jdbc* *occi* *mysql* *README *jar uidrvci genezi adrci; \
    echo /usr/lib/instantclient > /etc/ld.so.conf.d/oracle-instantclient.conf ;\
    ldconfig ;\
	fetch_ext oci8 https://pecl.php.net/get/oci8-3.4.1.tgz; \
	docker-php-ext-configure oci8 --with-oci8=instantclient,/usr/lib/instantclient; \
	docker-php-ext-install -j$(nproc) oci8; \
  rm -f /usr/local/bin/install-php-extensions; \
	\
	docker-php-source delete ;\
	apt-get remove -y g++ wget ;\
	apt-get autoremove --purge -y && apt-get autoclean -y && apt-get clean -y ;\
  rm -rf /var/lib/apt/lists/*; \
  rm -rf /tmp/* /var/tmp/*;

## Set php configuration overrides
RUN { \
            echo 'opcache.enable_cli=1'; \
    } > /usr/local/etc/php/conf.d/opcache-recommended.ini ; \
    { \
            echo 'date.timezone=Asia/Dhaka'; \
            echo 'upload_max_filesize=256M'; \
            echo 'post_max_size=2048M'; \
            echo 'max_input_vars=10000'; \
            echo 'memory_limit=3504M'; \
            echo 'expose_php = off'; \
            echo 'max_execution_time = 300'; \
    } > /usr/local/etc/php/conf.d/00-override.ini ; \
    { \
        echo 'error_reporting = 4339'; \
        echo 'display_errors = Off'; \
        echo 'display_startup_errors = Off'; \
        echo 'log_errors = On'; \
        echo 'error_log = /dev/stderr'; \
        echo 'log_errors_max_len = 1024'; \
        echo 'ignore_repeated_errors = On'; \
        echo 'ignore_repeated_source = Off'; \
        echo 'html_errors = Off'; \
    } > /usr/local/etc/php/conf.d/error-logging.ini ; \
    { \
            echo '[www]'; \
            echo 'request_terminate_timeout = 300'; \
            echo 'rlimit_files = 131072'; \
            echo 'rlimit_core = unlimited'; \
    } >> /usr/local/etc/php-fpm.d/zz-docker.conf

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

ENV COMPOSER_ALLOW_SUPERUSER=1
