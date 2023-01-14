# php-8-debain
Docker image with php:8.2.1-bullseye

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
### php-8-debain:cli
This use the cli base image also contain nodejs-18.x and npm

### php-8-debain:fpm
This use the fpm base image

### php-8-debain:apache
This use the apache base image

### php-8-debain:dev
This use the apache base image with xdebug enabled

### php-8-debain:supervisor
This use the fpm base image and set supervisor as entry point. Mount any supervisor config file as /etc/supervisor/conf.d/*.conf
