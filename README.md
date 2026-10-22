# php-8-debian
Docker images with PHP 8.5.12 on Debian Bookworm.

All variants provide the following PHP extensions (including extensions inherited from their base images):

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
- SimpleXML
- tokenizer
- Zend OPcache
- redis
- apcu
- yaml
- zip
- curl
- iconv
- xsl
- igbinary
- mongodb

The `apache`, `cli`, `dev`, `fpm`, `supervisor`, and `oci` variants also provide
AMQP, EXIF, SOAP, PostgreSQL (`pgsql`), and [Composer](https://github.com/composer/composer).
Xdebug is installed only in `cli` and `dev`. The `oci` variant additionally provides OCI8.
The FrankenPHP variants have their own extension set and do not install Composer.
OPcache is built into PHP 8.5 and does not need to be compiled or loaded separately.

## Image Variants

### php-8-debian:cli or php-8-debian:cli-{php-version}
This use the cli base image with xdebug enabled, also contain nodejs-24.x and npm

### php-8-debian:fpm or php-8-debian:fpm-{php-version}
This use the fpm base image

### php-8-debian:apache or php-8-debian:apache-{php-version}
This use the apache base image

### php-8-debian:dev or php-8-debian:dev-{php-version}
This use the apache base image with xdebug enabled

### php-8-debian:supervisor or php-8-debian:supervisor-{php-version}
This use the cli base image and set supervisor as entry point. Mount any supervisor config file as /etc/supervisor/conf.d/*.conf

### php-8-debian:franken or php-8-debian:franken-{php-version}
This use the dunglas/frankenphp base image

### php-8-debian:supervisor-franken or php-8-debian:supervisor-franken-{php-version}
This use the dunglas/frankenphp base image with github.com/baldinof/caddy-supervisor module
The custom binary uses the FrankenPHP and Caddy integration source bundled with
the PHP-matched builder image, plus Brotli, Mercure, and Supervisor modules.

### php-8-debian:oci or php-8-debian:oci-{php-version}
This uses the FPM base image with OCI8 and Oracle Instant Client. The Oracle
downloads currently target Linux x86-64, so build and run this variant on `linux/amd64`.

## Building and validation

Each Dockerfile defaults to PHP `8.5.12`. Build and validate a variant from the repository root:

```sh
docker build --pull --platform linux/amd64 --build-arg PHP_VERSION=8.5.12 \
  -t php-8-debian:check-fpm fpm
bash scripts/smoke-test.sh php-8-debian:check-fpm fpm 8.5.12
```

Replace `fpm` with the desired variant. The smoke checks verify the exact PHP
version, extensions, PDO drivers, serialization, and variant-specific tools.
Apache and FrankenPHP checks execute PHP over HTTP; Supervisor checks a PHP child
process. OCI checks load the client library; database connectivity requires a
separate integration test against an Oracle server.

CI builds all eight variants on `linux/amd64` for pull requests and main-branch
pushes. Each image must pass its smoke checks before it is published on a push to
`main`. Publication writes `{variant}-8.5.12`, `{variant}-8.5`, and `{variant}` tags;
FPM also updates `latest`. Pull requests and manual runs only build and validate.

The FrankenPHP variants require both upstream tags
`dunglas/frankenphp:1-php8.5.12-bookworm` and
`dunglas/frankenphp:1-builder-php8.5.12-bookworm`. Both tags were confirmed available
on 2026-10-22. If a required tag is unavailable, wait for upstream publication;
do not substitute an older PHP version for this security update.
