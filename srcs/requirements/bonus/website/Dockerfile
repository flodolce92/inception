FROM alpine:3.21

RUN apk update && apk add --no-cache nginx

# Create directory for nginx execution
RUN mkdir -p /run/nginx

# Copy config and static files
COPY conf/nginx.conf /etc/nginx/http.d/default.conf
COPY html/ /var/www/html/

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
