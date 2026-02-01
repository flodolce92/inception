#!/bin/sh

MYSQL_PASSWORD=$(cat /run/secrets/db_password)
WP_ADMIN_PASSWORD=$(cat /run/secrets/wp_admin_password)
WP_USER_PASSWORD=$(cat /run/secrets/wp_user_password)

if [ ! -f /var/www/html/wp-config.php ]; then
	echo "Downloading WordPress..."
	wp core download --allow-root

	echo "Creating wp-config.php..."
	wp config create \
		--dbname=$MYSQL_DATABASE \
		--dbuser=$MYSQL_USER \
		--dbpass=$MYSQL_PASSWORD \
		--dbhost=mariadb \
		--allow-root

	# wp config set WP_DEBUG true --raw --allow-root

	echo "Installing WordPress..."
	wp core install \
		--url=$DOMAIN_NAME \
		--title=$WP_TITLE \
		--admin_user=$WP_ADMIN_USER \
		--admin_password=$WP_ADMIN_PASSWORD \
		--admin_email=$WP_ADMIN_EMAIL \
		--skip-email \
		--allow-root

	echo "Creating second user..."
	wp user create \
		$WP_USER \
		$WP_USER_EMAIL \
		--role=author \
		--user_pass=$WP_USER_PASSWORD \
		--allow-root

	echo "Configuring Redis Cache..."
	wp config set WP_REDIS_HOST redis --allow-root
	wp config set WP_REDIS_PORT 6379 --allow-root
	wp plugin install redis-cache --activate --allow-root
	wp redis enable --allow-root
fi

echo "Setting permissions..."
chmod -R 775 /var/www/html
chown -R nobody:nobody /var/www/html

echo "Starting PHP-FPM..."
exec /usr/sbin/php-fpm82 -F
