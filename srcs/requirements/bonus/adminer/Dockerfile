FROM	alpine:3.22

RUN	apk add --no-cache \
	php83 \
	php83-common \
    	php83-session \
    	php83-mysqli \
    	php83-pdo \
    	php83-pdo_mysql \
    	php83-gd \
    	php83-iconv \
    	php83-xml \
    	php83-json \
    	php83-simplexml \
    	php83-zip \
    	php83-mbstring \
    	php83-curl \
    	php83-openssl \
    	php83-tokenizer \
    	php83-fileinfo \
    	php83-phar \
    	php83-dom \
    	&& rm -rf /var/cache/apk/*

COPY 	/tools/init.sh /usr/local/bin/adminer_init.sh

RUN 	chmod +x /usr/local/bin/adminer_init.sh && \
	adduser -D -u 1000 adminer && \
	mkdir -p /var/www/adminer && \
	chown -R adminer:adminer /var/www/adminer && \
    	chmod -R 755 /var/www/adminer

USER	adminer

CMD	["/usr/local/bin/adminer_init.sh"]
