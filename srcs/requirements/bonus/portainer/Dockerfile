FROM alpine:3.21

RUN apk update && apk add --no-cache \
	curl \
	tar \
	ca-certificates

RUN curl -L https://github.com/portainer/portainer/releases/download/2.16.2/portainer-2.16.2-linux-amd64.tar.gz -o portainer.tar.gz && \
	tar -xzvf portainer.tar.gz && \
	rm portainer.tar.gz && \
	mv portainer /usr/local/bin/

WORKDIR /usr/local/bin/portainer

RUN mkdir -p /data

EXPOSE 9000

CMD ["./portainer", "--no-analytics"]
