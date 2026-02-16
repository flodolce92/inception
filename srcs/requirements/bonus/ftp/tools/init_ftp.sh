#!/bin/sh

FTP_PASSWORD=$(cat /run/secrets/ftp_password)

if ! id "$FTP_USER" >/dev/null 2>&1; then
	echo "Creating FTP user..."
	adduser -D -h /var/www/html $FTP_USER
	echo "$FTP_USER:$FTP_PASSWORD" | chpasswd
	addgroup $FTP_USER nobody

	chown -R $FTP_USER:nobody /var/www/html
	chmod -R 775 /var/www/html
fi

echo "Configuring vsftpd..."
cat << EOF > /etc/vsftpd/vsftpd.conf
listen=YES
local_enable=YES
write_enable=YES
local_umask=002
dirmessage_enable=YES
use_localtime=YES
xferlog_enable=YES
connect_from_port_20=YES
chroot_local_user=YES
allow_writeable_chroot=YES
secure_chroot_dir=/var/empty
pam_service_name=vsftpd
pasv_enable=YES
pasv_min_port=21100
pasv_max_port=21110
pasv_address=0.0.0.0
seccomp_sandbox=NO
EOF

echo "Starting FTP server..."
exec /usr/sbin/vsftpd /etc/vsftpd/vsftpd.conf
