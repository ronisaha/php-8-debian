# php-8-debain
Docker image with php:8.3.x-bullseye

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
### php-8-debain:cli or php-8-debain:cli-{php-version}
This use the cli base image with xdebug enabled, also contain nodejs-20.x and npm

### php-8-debain:fpm or php-8-debain:fpm-{php-version}
This use the fpm base image

### php-8-debain:apache or php-8-debain:apache-{php-version}
This use the apache base image

### php-8-debain:dev or php-8-debain:dev-{php-version}
This use the apache base image with xdebug enabled

### php-8-debain:oci or php-8-debain:oci-{php-version}
This use the fpm base image with oci8 extension enabled.

### php-8-debain:supervisor or php-8-debain:supervisor-{php-version}
This use the cli base image and set supervisor as entry point. Mount any supervisor config file as /etc/supervisor/conf.d/*.conf
