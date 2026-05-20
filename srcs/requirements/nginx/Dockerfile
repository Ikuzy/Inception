FROM	alpine:3.22

RUN	apk update && apk upgrade && \
    	apk add --no-cache nginx openssl netcat-openbsd && \
    	rm -rf /var/cache/apk/* && \
    	mkdir -p /etc/nginx/ssl

COPY	tools/Nginx_script /usr/local/bin/Nginx_init.sh
COPY	conf/def.conf /etc/nginx/http.d/wordpress.conf
COPY    conf/ss.conf /etc/nginx/http.d/staticsite.conf


RUN	chmod +x /usr/local/bin/Nginx_init.sh 

CMD	["/usr/local/bin/Nginx_init.sh"]
