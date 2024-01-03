# php-8-debian
Docker image with php:8.2.x-bullseye

All image contain following php extension, [wkhtmltopdf-0.12.6](https://github.com/wkhtmltopdf/wkhtmltopdf/) with patched QT, [merge2pdf](https://github.com/ajaxray/merge2pdf) and [composer](https://github.com/composer/composer).

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
- oci8
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

## Image Variants
### php-8-debian:cli or php-8-debian:cli-{php-version}
This use the cli base image with xdebug enabled, also contain nodejs-18.x and npm

### php-8-debian:fpm or php-8-debian:fpm-{php-version}
This use the fpm base image

### php-8-debian:apache or php-8-debian:apache-{php-version}
This use the apache base image

### php-8-debian:dev or php-8-debian:dev-{php-version}
This use the apache base image with xdebug enabled

### php-8-debian:supervisor or php-8-debian:supervisor-{php-version}
This use the fpm base image and set supervisor as entry point. Mount any supervisor config file as /etc/supervisor/conf.d/*.conf
