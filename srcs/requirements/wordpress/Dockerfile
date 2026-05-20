FROM alpine:3.22

# Install PHP and required extensions
RUN apk update && apk upgrade && \
    apk add --no-cache \
    php83 \
    php83-fpm \
    php83-mysqli \
    php83-curl \
    php83-dom \
    php83-mbstring \
    php83-pecl-redis \
    php83-gd \
    php83-phar \
    php83-tokenizer \
    php83-session \
    php83-openssl \
    php83-xml \
    php83-zip \
    php83-fileinfo \
    php83-exif \
    php83-iconv \
    redis \
    mariadb-client && \
    rm -rf /var/cache/apk/*

RUN addgroup -g 82 -S www-data 2>/dev/null || true && \
    adduser -u 82 -D -S -G www-data -H -h /var/www -s /sbin/nologin www-data 2>/dev/null || true && \
    adduser -u 65534 -D -S -H -h /var/www/html -s /bin/sh nobody 2>/dev/null || true

RUN echo 'memory_limit = 256M' > /etc/php83/conf.d/memory.ini

RUN echo '[Session]' > /etc/php83/conf.d/redis-session.ini && \
    echo 'session.save_handler = redis' >> /etc/php83/conf. d/redis-session.ini && \
    echo 'session.save_path = "tcp://redis:6379? database=1"' >> /etc/php83/conf.d/redis-session.ini

RUN mkdir -p /var/www/html && \
    chown -R www-data:www-data /var/www/html

RUN sed -i 's/listen = 127.0.0.1:9000/listen = 9000/g' /etc/php83/php-fpm.d/www.conf && \
    sed -i 's/;clear_env = no/clear_env = no/g' /etc/php83/php-fpm.d/www.conf && \
    sed -i 's/user = nobody/user = www-data/g' /etc/php83/php-fpm.d/www.conf && \
    sed -i 's/group = nobody/group = www-data/g' /etc/php83/php-fpm.d/www.conf && \
    sed -i 's/;listen.owner = nobody/listen.owner = www-data/g' /etc/php83/php-fpm.d/www.conf && \
    sed -i 's/;listen.group = nobody/listen.group = www-data/g' /etc/php83/php-fpm.d/www.conf

RUN wget -q -O /usr/local/bin/wp https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x /usr/local/bin/wp

COPY tools/wp_script /usr/local/bin/wp_init.sh
RUN chmod +x /usr/local/bin/wp_init.sh

CMD ["/usr/local/bin/wp_init.sh"]
