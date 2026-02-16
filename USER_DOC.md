# User Documentation

This guide covers the configuration steps needed to run the Inception infrastructure on your machine and access the various services it provides.

## Network Configuration

The project uses a custom domain (flo-dolc.42.fr) that needs to be mapped to your local machine. This is done by editing your hosts file.

1. Open your hosts file with elevated privileges:

   ```bash
   sudo vim /etc/hosts
   ```

2. Add these entries at the end of the file:

   ```text
   127.0.0.1   flo-dolc.42.fr
   127.0.0.1   adminer.flo-dolc.42.fr
   127.0.0.1   site.flo-dolc.42.fr
   127.0.0.1   portainer.flo-dolc.42.fr
   127.0.0.1   kuma.flo-dolc.42.fr
   ```

3. Save the file and exit the editor.

## Environment Setup

Create a `.env` file in the `srcs/` directory with the following variables:

```dotenv
DOMAIN_NAME=flo-dolc.42.fr

# MySQL Setup
MYSQL_DATABASE=wordpress
MYSQL_USER=wp_user

# WordPress Setup
WP_TITLE=Inception
WP_ADMIN_USER=admin
WP_ADMIN_EMAIL=admin@student.42.fr
WP_USER=editor
WP_USER_EMAIL=editor@student.42.fr

# FTP Setup
FTP_USER=ftp_user
```

## Secrets Configuration

Passwords are stored as Docker secrets in the `secrets/` directory at the project root. Create the following files with your passwords:

- `secrets/db_root_password.txt` - MariaDB root password
- `secrets/db_password.txt` - MariaDB user password
- `secrets/wp_admin_password.txt` - WordPress admin password
- `secrets/wp_user_password.txt` - WordPress editor user password
- `secrets/ftp_password.txt` - FTP user password

Make sure to use strong passwords for all services. Each file should contain only the password with no trailing newline.

## Accessing Services

All services are accessed through HTTPS on port 443. Your browser will show a security warning because the project uses a self-signed certificate - this is expected behavior for local development. You can safely proceed past the warning.

### Service URLs and Credentials

**WordPress**

- URL: https://flo-dolc.42.fr
- Purpose: Main website and content management
- Username: Value from WP_ADMIN_USER in .env
- Password: Value from secrets/wp_admin_password.txt

**Adminer**

- URL: https://adminer.flo-dolc.42.fr
- Purpose: Database administration interface
- Server: mariadb
- Username: Value from MYSQL_USER in .env
- Password: Value from secrets/db_password.txt

**Static Website**

- URL: https://site.flo-dolc.42.fr
- Purpose: Static HTML showcase
- No login required

**Portainer**

- URL: https://portainer.flo-dolc.42.fr
- Purpose: Docker container management
- First visit: Create an admin account
- Subsequent visits: Use the account you created

**Uptime Kuma**

- URL: https://kuma.flo-dolc.42.fr
- Purpose: Service monitoring and uptime tracking
- First visit: Create an admin account
- Subsequent visits: Use the account you created

## FTP Access

The FTP server provides direct access to WordPress files. Use these settings in your FTP client:

- Host: localhost (or 127.0.0.1)
- Port: 21
- Protocol: FTP
- Transfer Mode: Passive (PASV)
- Passive Port Range: 21100-21110
- Username: Value from FTP_USER in .env
- Password: Value from secrets/ftp_password.txt

## Troubleshooting

**502 Bad Gateway Error**
This typically means a container is still initializing. Wait 10-20 seconds and refresh the page. WordPress and MariaDB can take a moment to fully start up.

**Connection Refused Error**
Check that all containers are running with `docker ps`. If containers are missing, run `make` again and check the build logs for errors.

**FTP Permission Errors**
The FTP user must be in the correct group to access WordPress files. Check the logs with `docker logs ftp` to verify the user was created properly during initialization.

**Database Connection Error**
This can happen if the MariaDB container has stale data. Try stopping everything with `make clean`, then rebuild with `make`. You can also check the database logs with `docker logs mariadb` for specific error messages.
