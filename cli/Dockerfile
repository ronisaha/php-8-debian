ARG PHP_VERSION=8.4.7
FROM php:${PHP_VERSION}-cli-bookworm

LABEL org.opencontainers.image.authors="Roni Kumar Saha <roni.csed@gmail.com>"

ENV LD_LIBRARY_PATH=/usr/lib/instantclient

ENV NODE_MAJOR=20
#install Exetentions and dependencies
RUN set -eux; \
	\
	apt-get update && apt-get -y upgrade; \
    apt-get install -y ca-certificates curl gnupg; \
    mkdir -p /etc/apt/keyrings; \
    curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg; \
    export NODE_MAJOR=20; \
    echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list; \
    apt-get update; \
	apt-get install -y libaio1 wget unzip \
		libicu-dev \
       libzip-dev \
        libyaml-dev \
        gettext graphviz \
        libmagickwand-dev \
        librabbitmq-dev \
        libpq-dev  \
        libxslt1-dev \
        libjpeg62-turbo \
        libpng16-16 \
	; \
	\
  apt-get -y install nodejs; \
  pecl install apcu; \
  pecl install yaml; \
  pecl install igbinary; \
  pecl install mongodb; \
  docker-php-ext-enable apcu yaml igbinary mongodb; \
  docker-php-ext-install -j$(nproc) iconv; \
  docker-php-ext-configure intl; \
  docker-php-ext-install -j$(nproc) intl; \
  docker-php-ext-install -j$(nproc) \
        exif \
        bcmath \
        xsl \
        gettext \
        opcache \
        pdo \
        pdo_mysql \
        pdo_pgsql \
        pgsql \
        soap \
        zip \
        sockets; \
  echo 'yes,yes' | pecl install redis; \
  docker-php-ext-enable redis; \
    pecl install xdebug; \
	docker-php-ext-enable xdebug; \
	curl -L https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions > /usr/local/bin/install-php-extensions \
    ; \
  chmod +x /usr/local/bin/install-php-extensions ; \
  install-php-extensions gd amqp; \
  rm -f /usr/local/bin/install-php-extensions; \
	\
	docker-php-source delete ;\
	apt-get remove -y g++ wget ;\
	apt-get autoremove --purge -y && apt-get autoclean -y && apt-get clean -y ;\
  rm -rf /var/lib/apt/lists/*; \
  rm -rf /tmp/* /var/tmp/*;

## Set php configuration
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
    } > /usr/local/etc/php/conf.d/error-logging.ini

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

ENV COMPOSER_ALLOW_SUPERUSER=1
