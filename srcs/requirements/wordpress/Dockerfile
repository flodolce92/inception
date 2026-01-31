FROM alpine:3.21

RUN apk update && apk add --no-cache \
	php82 \
	php82-fpm \
	php82-mysqli \
	php82-phar \
	php82-mbstring \
	php82-openssl \
	php82-curl \
	php82-zlib \
	php82-redis \
	php82-tokenizer \
	php82-ctype \
	php82-dom \
	php82-xml \
	wget \
	mariadb-client

RUN sed -i "s|;*memory_limit =.*|memory_limit = 512M|i" /etc/php82/php.ini
RUN ln -s /usr/bin/php82 /usr/bin/php

RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
	chmod +x wp-cli.phar && \
	mv wp-cli.phar /usr/local/bin/wp

COPY ./conf/www.conf /etc/php82/php-fpm.d/www.conf
COPY ./tools/init_wp.sh /init_wp.sh
RUN chmod +x /init_wp.sh

WORKDIR /var/www/html

EXPOSE 9000

CMD ["/init_wp.sh"]
