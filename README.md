# php-8.0-buster
Docker image with php-8.0.13-buster

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
- oci8-3.0.1
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
### php-8.0-buster:cli
This use the cli base image also contain nodejs and npm

### php-8.0-buster:fpm or php-8.0-buster:latest
This use the fpm base image

### php-8.0-buster:apache
This use the apache base image

### php-8.0-buster:dev
This use the apache base image with xdebug enabled

### php-8.0-buster:supervisor
This use the fpm base image and set supervisor as entry point. Mount any supervisor config file as /etc/supervisor/conf.d/*.conf
