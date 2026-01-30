#!/bin/sh

MYSQL_ROOT_PASSWORD=$(cat /run/secrets/db_root_password)
MYSQL_PASSWORD=$(cat /run/secrets/db_password)

# Check if the database is already initialized
if [ ! -d "/var/lib/mysql/mysql" ]; then
	echo "Initializing database..."
	mysql_install_db --user=mysql --datadir=/var/lib/mysql

	echo "Creating init file..."
	cat << EOF > /tmp/create_db.sql
USE mysql;
FLUSH PRIVILEGES;

DELETE FROM mysql.user WHERE User='';
DROP DATABASE test;
DELETE FROM mysql.db WHERE Db='test';
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');

ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';

CREATE DATABASE ${MYSQL_DATABASE} CHARACTER SET utf8 COLLATE utf8_general_ci;
CREATE USER '${MYSQL_USER}'@'%' IDENTIFIED by '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';

FLUSH PRIVILEGES;
EOF

	# Run the bootstrap mode to execute the SQL
	/usr/bin/mysqld --user=mysql --bootstrap < /tmp/create_db.sql
	rm -f /tmp/create_db.sql
	echo "Database initialized."
fi

# Start MariaDB normally
exec /usr/bin/mysqld --user=mysql --console
