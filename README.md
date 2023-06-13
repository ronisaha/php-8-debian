# php-8-debain
Docker image with php:8.2.7-bullseye

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
### php-8-debain:cli or php-8-debain:cli-{php-version}
This use the cli base image also contain nodejs-18.x and npm

### php-8-debain:fpm or php-8-debain:fpm-{php-version}
This use the fpm base image

### php-8-debain:apache or php-8-debain:apache-{php-version}
This use the apache base image

### php-8-debain:dev or php-8-debain:dev-{php-version}
This use the apache base image with xdebug enabled

### php-8-debain:supervisor or php-8-debain:supervisor-{php-version}
This use the fpm base image and set supervisor as entry point. Mount any supervisor config file as /etc/supervisor/conf.d/*.conf
