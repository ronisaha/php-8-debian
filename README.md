# php-8-debian
Docker image with php:8.3.x-bookworm

All image contain following php extension and [composer](https://github.com/composer/composer).

- bcmath
- gd
- intl
- json
- libxml
- mbstring
- openssl
- PDO
- pdo_pgsql
- pdo_mysql
- oci8(Only in oci variant)
- SimpleXML
- tokenizer
- Zend OPcache
- amqp
- redis
- apcu
- yaml
- zip
- curl
- exif
- iconv
- xdebug(Only in cli and dev variant)

## Image Variants
### php-8-debian:cli or php-8-debian:cli-{php-version}
This use the cli base image with xdebug enabled, also contain nodejs-20.x and npm

### php-8-debian:fpm or php-8-debian:fpm-{php-version}
This use the fpm base image

### php-8-debian:apache or php-8-debian:apache-{php-version}
This use the apache base image

### php-8-debian:dev or php-8-debian:dev-{php-version}
This use the apache base image with xdebug enabled

### php-8-debian:supervisor or php-8-debian:supervisor-{php-version}
This use the cli base image and set supervisor as entry point. Mount any supervisor config file as /etc/supervisor/conf.d/*.conf

### php-8-debian:oci or php-8-debian:oci-{php-version}
This use the fpm base image with oci8 extension enabled.

### php-8-debian:oci or php-8-debian:supervisor-oci-{php-version}
This use the fpm base image with oci8 extension enabled and set supervisor as entry point. Mount any supervisor config file as /etc/supervisor/conf.d/*.conf

### php-8-debian:franken or php-8-debian:franken-{php-version}
This use the dunglas/frankenphp:1-php{8.3}-bookworm base image
