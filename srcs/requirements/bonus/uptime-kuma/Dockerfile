FROM alpine:3.21

RUN apk update && apk add --no-cache \
	nodejs \
	npm \
	git \
	python3 \
	make \
	g++

WORKDIR /app

RUN git clone https://github.com/louislam/uptime-kuma.git . && \
	npm install && \
	npm run setup

EXPOSE 3001

CMD ["node", "server/server.js"]
