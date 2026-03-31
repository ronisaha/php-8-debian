ARG PHP_VERSION=8.5.4
FROM php:${PHP_VERSION}-fpm-bookworm

LABEL org.opencontainers.image.authors="Roni Kumar Saha <roni.csed@gmail.com>"

RUN set -eux; \
    export DEBIAN_FRONTEND=noninteractive; \
    echo 'Acquire::Retries "5";' > /etc/apt/apt.conf.d/80-retries; \
    echo 'Acquire::http::Timeout "30";' > /etc/apt/apt.conf.d/80-timeout; \
    if [ -f /etc/apt/sources.list.d/debian.sources ]; then \
        sed -i 's/^Components: main$/Components: main contrib non-free non-free-firmware/' /etc/apt/sources.list.d/debian.sources; \
    elif [ -f /etc/apt/sources.list ]; then \
        sed -i'.bak' 's/ main$/ main contrib non-free/' /etc/apt/sources.list; \
    fi; \
    echo "ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true" | debconf-set-selections

#install Exetentions and dependencies
RUN set -eux; \
	apt-get update && apt-get -y upgrade; \
	apt-get install -y libaio1 wget unzip \
		libicu-dev \
        libzip-dev \
        libyaml-dev \
        gettext graphviz \
        libmagickwand-dev \
        librabbitmq-dev \
        libpq-dev  \
        imagemagick \
        libxslt1-dev \
        \
        fontconfig \
        libfreetype6 \
        libjpeg62-turbo \
        libpng16-16 \
        libx11-6 \
        libxcb1 \
        libxext6 \
        libxrender1 \
        xfonts-75dpi \
        xfonts-base \
        ttf-mscorefonts-installer \
	; \
	\
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
        pdo \
        pdo_mysql \
        pdo_pgsql \
        pgsql \
        soap \
        zip \
        gd \
        sockets; \
  echo 'yes,yes' | pecl install redis; \
  docker-php-ext-enable redis; \
    cd /tmp; \
      curl -L -O https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6.1-3/wkhtmltox_0.12.6.1-3.bookworm_amd64.deb; \
      dpkg -i wkhtmltox_0.12.6.1-3.bookworm_amd64.deb; \
      rm -rf wkhtmltox_0.12.6.1-3.bookworm_amd64.deb; \
  	curl -L https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions > /usr/local/bin/install-php-extensions \
    ; \
    chmod +x /usr/local/bin/install-php-extensions ; \
    install-php-extensions php-amqp/php-amqp@977449987412a3d5c59a036dbab8b6d67764bb3e; \
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
            echo 'request_terminate_timeout = 300'; \
            echo 'rlimit_files = 131072'; \
            echo 'rlimit_core = unlimited'; \
    } >> /usr/local/etc/php-fpm.d/zz-docker.conf

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

ENV COMPOSER_ALLOW_SUPERUSER=1

RUN set -eux; \
    	\
    	curl -L https://github.com/ajaxray/merge2pdf/releases/download/v1.1.0/merge2pdf_linux-amd64.OS -o /usr/local/bin/merge2pdf; \
      chmod +x /usr/local/bin/merge2pdf
## Copy Custom Fonts
COPY fonts /usr/share/fonts/truetype
RUN fc-cache -f -v
