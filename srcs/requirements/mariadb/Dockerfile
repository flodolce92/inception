FROM alpine:3.21

ENV MYSQL_DIR=/var/lib/mysql

RUN apk update && apk add --no-cache \
	mariadb mariadb-client && \
	mkdir -p "$MYSQL_DIR" && \
	chown -R mysql:mysql "$MYSQL_DIR" && \
	chmod 755 "$MYSQL_DIR" && \
	mysql_install_db --user=mysql --datadir="$MYSQL_DIR"

RUN mkdir -p /run/mysqld && chown -R mysql:mysql /run/mysqld
COPY ./conf/my.cnf /etc/my.cnf
COPY ./tools/init.sh /init.sh
RUN chmod +x /init.sh

EXPOSE 3306

CMD ["/init.sh"]
