FROM alpine:3.21

RUN apk update && apk add --no-cache vsftpd

COPY ./tools/init_ftp.sh /init_ftp.sh
RUN chmod +x /init_ftp.sh

# FTP ports
# 20 - Data Transfer
# 21 - Command Control
# 21100-21110 - Passive Mode Data Transfer
EXPOSE 20 21 21100-21110

CMD ["/init_ftp.sh"]
