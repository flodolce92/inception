FROM alpine:3.21

RUN apk update && apk add --no-cache \
	nginx \
	openssl

# Certificate creation
RUN mkdir -p /etc/nginx/ssl
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
	-keyout /etc/nginx/ssl/inception.key \
	-out /etc/nginx/ssl/inception.crt \
	-subj "/C=IT/ST=Lazio/L=Rome/O=42/OU=42/CN=*.flo-dolc.42.fr/UID=flo-dolc"

COPY ./conf/nginx.conf /etc/nginx/nginx.conf

# Create directory for nginx execution
RUN mkdir -p /run/nginx

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]
