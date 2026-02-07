FROM alpine:3.21

RUN apk update && apk add --no-cache \
	mariadb \
	mariadb-client

# Create the run directory for the socket
RUN mkdir -p /run/mysqld && chown -R mysql:mysql /run/mysqld

COPY ./conf/my.cnf /etc/my.cnf
COPY ./tools/init.sh /init.sh
RUN chmod +x /init.sh

EXPOSE 3306

CMD ["/init.sh"]
