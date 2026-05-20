FROM	alpine:3.22

RUN	apk update && apk upgrade && \
    	apk add --no-cache vsftpd && \
    	rm -rf /var/cache/apk/*

RUN	sed -i 's|nobody:x:65534:65534:nobody:/:/sbin/nologin|nobody:x:65534:65534:nobody:/var/www/html:/bin/sh|' /etc/passwd

RUN 	mkdir -p /var/www/html && \
    	mkdir -p /var/run/vsftpd/empty && \
    	mkdir -p /var/log

RUN 	chown -R nobody:nobody /var/www/html && \
    	chmod 755 /var/www/html

COPY 	conf/def.conf		/etc/vsftpd/vsftpd.conf
COPY 	tools/vsftp_init 	/usr/local/bin/vsftp.sh

RUN 	chmod +x /usr/local/bin/vsftp.sh && \
    	chmod 644 /etc/vsftpd/vsftpd.conf

CMD	["/usr/local/bin/vsftp.sh"]
