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

	# Customization
	echo "Installing Blocksy theme..."
	wp theme install blocksy --activate --allow-root
	echo "Installing WP Dark Mode plugin..."
	wp plugin install wp-dark-mode --activate --allow-root

	# Dark mode
	wp option update wp_dark_mode_general '{"enable_frontend":true,"enable_backend":false,"enable_os_mode":true}' --format=json --allow-root
	wp option update wp_dark_mode_trigger '{"enable_frontend_mode_by_default":true}' --format=json --allow-root

	# Remove default content
	echo "Removing default content..."
	wp post delete 1 --force --allow-root
	wp post delete 2 --force --allow-root
	wp comment delete 1 --force --allow-root

	# Create mock articles
	echo "Creating mock articles..."

	# Article 1: 42 Rome
	POST_CONTENT_1=$(cat /content/post_42_rome.html)
	wp post create \
		--post_type=post \
		--post_title='42 Roma: Revolutionizing Tech Education in Italy' \
		--post_content="$POST_CONTENT_1" \
		--post_status=publish \
		--post_author=1 \
		--allow-root

	# Article 2: Gamification in 42
	POST_CONTENT_2=$(cat /content/post_gamification.html)
	wp post create \
		--post_type=post \
		--post_title='Gamification at 42 School: Learning Through Play' \
		--post_content="$POST_CONTENT_2" \
		--post_status=publish \
		--post_author=1 \
		--allow-root

	echo "WordPress initialization complete with 42 School content!"
fi

echo "Setting permissions..."
chmod -R 775 /var/www/html
chown -R nobody:nobody /var/www/html

echo "Starting PHP-FPM..."
exec /usr/sbin/php-fpm82 -F
