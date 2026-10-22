#!/usr/bin/env bash
set -euo pipefail

image=${1:?Usage: smoke-test.sh IMAGE VARIANT PHP_VERSION}
variant=${2:?Missing image variant}
php_version=${3:?Missing expected PHP version}

case "$variant" in
  apache|cli|dev|fpm|supervisor|oci|franken|supervisor-franken) ;;
  *) echo "Unknown variant: $variant" >&2; exit 1 ;;
esac

# Override entrypoints so Supervisor and FrankenPHP also run the CLI checks.
docker run --rm -i --entrypoint php \
  -e EXPECTED_PHP_VERSION="$php_version" -e IMAGE_VARIANT="$variant" "$image" <<'PHP'
<?php
if (PHP_VERSION !== getenv('EXPECTED_PHP_VERSION')) {
    throw new RuntimeException('Unexpected PHP version: ' . PHP_VERSION);
}
$variant = getenv('IMAGE_VARIANT');
$extensions = ['bcmath', 'gd', 'intl', 'json', 'libxml', 'mbstring', 'openssl',
    'PDO', 'pdo_pgsql', 'pdo_mysql', 'SimpleXML', 'tokenizer', 'Zend OPcache',
    'redis', 'apcu', 'yaml', 'zip', 'curl', 'iconv', 'xsl', 'gettext',
    'sockets', 'igbinary', 'mongodb'];
if (!in_array($variant, ['franken', 'supervisor-franken'], true)) {
    array_push($extensions, 'amqp', 'exif', 'soap', 'pgsql');
}
if (in_array($variant, ['cli', 'dev'], true)) {
    $extensions[] = 'xdebug';
} elseif (extension_loaded('xdebug')) {
    throw new RuntimeException('Xdebug should only be enabled in cli/dev');
}
if ($variant === 'oci') {
    $extensions[] = 'oci8';
    if (!oci_client_version()) {
        throw new RuntimeException('Oracle client library did not load');
    }
}
foreach ($extensions as $extension) {
    if (!extension_loaded($extension)) {
        throw new RuntimeException('Missing extension: ' . $extension);
    }
}
if (!in_array('mysql', PDO::getAvailableDrivers(), true)
    || !in_array('pgsql', PDO::getAvailableDrivers(), true)) {
    throw new RuntimeException('Missing PDO database drivers');
}
if (igbinary_unserialize(igbinary_serialize(['php' => PHP_VERSION])) !== ['php' => PHP_VERSION]) {
    throw new RuntimeException('igbinary round trip failed');
}
echo $variant . ': PHP ' . PHP_VERSION . ' and extensions verified' . PHP_EOL;
PHP

case "$variant" in
  franken|supervisor-franken) ;;
  *) docker run --rm --entrypoint composer "$image" --version ;;
esac

case "$variant" in
  cli)
    docker run --rm --entrypoint sh "$image" -ec 'node --version | grep -E "^v24\."; npm --version'
    ;;
  fpm|oci)
    docker run --rm --entrypoint php-fpm "$image" -t
    ;;
  apache|dev)
    docker run --rm --entrypoint apache2ctl "$image" -t
    ;;
  supervisor-franken)
    docker run --rm --entrypoint frankenphp "$image" list-modules | grep -F supervisor
    ;;
esac

# Exercise the default entrypoint without exposing ports on the host.
container_id=''
test_dir=$(mktemp -d)
cleanup() {
  if [ -n "$container_id" ]; then
    docker logs "$container_id" || true
    docker rm -fv "$container_id" >/dev/null || true
  fi
  rm -rf "$test_dir"
}
trap cleanup EXIT

case "$variant" in
  fpm|oci)
    container_id=$(docker create "$image")
    docker start "$container_id" >/dev/null
    for attempt in {1..30}; do
      if docker exec "$container_id" php -r \
        '$socket = @fsockopen("127.0.0.1", 9000); exit($socket ? 0 : 1);'; then
        exit 0
      fi
      sleep 1
    done
    echo 'FPM startup smoke test failed' >&2
    exit 1
    ;;
  apache|dev|franken|supervisor-franken)
    document_root=/var/www/public
    expected_sapi=apache2handler
    if [[ "$variant" == *franken* ]]; then
      document_root=/app/public
      expected_sapi=frankenphp
    fi
    container_id=$(docker create -e SERVER_NAME=:80 "$image")
    printf '<?php echo PHP_VERSION . ":" . PHP_SAPI;' > "$test_dir/version.php"
    chmod 755 "$test_dir"
    chmod 644 "$test_dir/version.php"
    docker cp "$test_dir/." "$container_id:$document_root"
    docker start "$container_id" >/dev/null
    for attempt in {1..30}; do
      if docker exec "$container_id" php -r \
        'exit(@file_get_contents("http://127.0.0.1/version.php") === $argv[1] ? 0 : 1);' \
        "$php_version:$expected_sapi"; then
        exit 0
      fi
      sleep 1
    done
    echo 'HTTP PHP smoke test failed' >&2
    exit 1
    ;;
  supervisor)
    printf '[program:php-smoke]\ncommand=php -r "echo PHP_VERSION, PHP_EOL; sleep(60);"\nstdout_logfile=/dev/stdout\nstdout_logfile_maxbytes=0\nstderr_logfile=/dev/stderr\nstderr_logfile_maxbytes=0\n' > "$test_dir/php-smoke.conf"
    container_id=$(docker create "$image")
    docker cp "$test_dir/php-smoke.conf" "$container_id:/etc/supervisor/conf.d/php-smoke.conf"
    docker start "$container_id" >/dev/null
    for attempt in {1..30}; do
      if docker logs "$container_id" 2>&1 | grep -Fx "$php_version"; then
        exit 0
      fi
      sleep 1
    done
    echo 'Supervisor PHP child process smoke test failed' >&2
    exit 1
    ;;
esac
