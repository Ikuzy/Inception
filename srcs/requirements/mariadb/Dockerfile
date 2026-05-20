FROM 	alpine:3.22

RUN 	apk update && apk upgrade && \
	apk add --no-cache mariadb mariadb-client && \
    	rm -rf /var/cache/apk/*

RUN 	mkdir -p /run/mysqld /var/lib/mysql && \
    	chown -R mysql:mysql /run/mysqld /var/lib/mysql && \
	mkdir -p /var/log/mysql && chown mysql:mysql /var/log/mysql

COPY 	conf/def.cnf /etc/my.cnf.d/mariadb-server.cnf

COPY 	tools/mariaDB_script /usr/local/bin/mariaDB_init.sh

RUN 	chmod +x /usr/local/bin/mariaDB_init.sh

EXPOSE 	3306

CMD 	["/usr/local/bin/mariaDB_init.sh"]
