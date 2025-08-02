#!/bin/sh

echo "Creating initdb.d directory..."
mkdir -p initdb.d
echo "Directory created succesfully!"

# Generate initialization SQL file
echo "Creating init.sql file..."
echo "CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};" > /initdb.d/init.sql

# Set up user and privileges
echo "CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';" >> /initdb.d/init.sql
echo "GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';" >> /initdb.d/init.sql

# Set up root user
echo "ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';" >> /initdb.d/init.sql
echo "CREATE USER IF NOT EXISTS 'root'@'%' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';" >> /initdb.d/init.sql
echo "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;" >> /initdb.d/init.sql

# Flush privileges to ensure changes take effect
echo "FLUSH PRIVILEGES;" >> /initdb.d/init.sql

echo "init.sql created succesfully!"

echo "======== Starting Mariadb ========"
exec mariadbd --datadir="$MYSQL_DIR" --user=mysql --init-file=/initdb.d/init.sql
