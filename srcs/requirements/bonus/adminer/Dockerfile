FROM alpine:3.21

RUN apk update && apk add --no-cache \
	php82 \
	php82-common \
	php82-session \
	php82-iconv \
	php82-gd \
	php82-xml \
	php82-mysqli \
	php82-imap \
	php82-cgi \
	php82-pdo \
	php82-pdo_mysql \
	php82-soap \
	php82-posix \
	php82-gettext \
	php82-ldap \
	php82-ctype \
	php82-dom \
	wget

RUN ln -s /usr/bin/php82 /usr/bin/php

WORKDIR /var/www

RUN wget "https://github.com/vrana/adminer/releases/download/v5.4.1/adminer-5.4.1.php" -O index.php

EXPOSE 8080

CMD ["php", "-S", "0.0.0.0:8080"]
