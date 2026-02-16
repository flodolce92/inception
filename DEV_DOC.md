# Developer Documentation

## Project Abstract

Inception is a System Administration project that involves building a complete, containerized infrastructure using Docker and Docker Compose. The goal is to set up a specific network of services—including a LEMP stack and various administration tools—following a strict microservices architecture. Each service runs in a dedicated Alpine Linux 3.21 container.

This project implements the Mandatory part (LEMP Stack) and the Bonus part (Cache, FTP, Adminer, Static Site, Portainer, Monitoring).

## Infrastructure Architecture

The infrastructure is orchestrated via `docker-compose.yml`. It is divided into two isolated internal networks to ensure security and separation of concerns.

### Network Topology

The host machine exposes only port 443 to the outside world. Internally, two networks handle different aspects of the infrastructure:

- `proxy-network`: A frontend network that connects NGINX to public-facing services (WordPress, Adminer, Website, Portainer, Uptime Kuma).
- `db-network`: A backend network that connects application logic (WordPress, Adminer, Uptime Kuma) to the database (MariaDB) and cache (Redis).

The database (MariaDB) and Cache (Redis) are completely isolated from the host and the proxy network. They are accessible only by specific containers on the `db-network`.

## Mandatory Services Implementation

### NGINX (Reverse Proxy & SSL Termination)

**Image**: Built from `alpine:3.21`

NGINX serves as the sole entry point into the infrastructure, handling all incoming HTTP traffic. It listens on port 443 (HTTPS) and uses TLSv1.2 and TLSv1.3 protocols. A self-signed wildcard certificate (`*.flo-dolc.42.fr`) is generated via OpenSSL during the build.

Routing is handled as follows:

- `flo-dolc.42.fr` proxies to WordPress:9000 (via FastCGI)
- `adminer.flo-dolc.42.fr` proxies to Adminer:8080
- `site.flo-dolc.42.fr` proxies to Website:80
- `portainer.flo-dolc.42.fr` proxies to Portainer:9000
- `kuma.flo-dolc.42.fr` proxies to Uptime Kuma:3001

### MariaDB (Database Engine)

**Image**: Built from `alpine:3.21`

MariaDB provides persistent data storage for WordPress and other services. A custom entrypoint script (`init.sh`) initializes the data directory and creates the database (`wordpress`), a root user, and a standard user (`wp_user`) based on environment variables.

The service implements a `mysqladmin ping` healthcheck. Dependent services (WordPress, Adminer) wait for this check to pass before starting. MariaDB is exposed only on `db-network` (Port 3306).

### WordPress (PHP-FPM)

**Image**: Built from `alpine:3.21`

WordPress serves as the primary application server, running PHP 8.2 FPM (FastCGI Process Manager) on port 9000. The service uses `wp-cli` (WordPress Command Line Interface) to download core files, generate `wp-config.php`, and install the site automatically. As a bonus integration, it automatically installs and configures the "Redis Object Cache" plugin to connect to the Redis container.

## Bonus Services Implementation

### Redis (Object Cache)

Redis is a high-performance in-memory key-value store that caches WordPress database queries to reduce load on MariaDB and improve page load times. It's configured with `maxmemory-policy allkeys-lru` to evict old keys when memory is full.

### FTP Server (vsftpd)

The FTP server provides direct file management access to the WordPress volume. It runs `vsftpd` (Very Secure FTP Daemon) and the FTP user is added to the `nobody` group (the group used by PHP/NGINX) to ensure write permissions on `/var/www/html`. The service exposes standard port 21 and a range of passive ports (21100-21110) to the host.

### Adminer (Database Management)

Adminer is a lightweight web UI for managing the MariaDB database. It uses PHP's built-in server running a single PHP file and is accessible via `https://adminer.flo-dolc.42.fr`.

### Static Website (Nginx)

A simple HTML/CSS showcase page is served by a dedicated NGINX container (distinct from the main proxy) running on port 80 internally. It's accessible via `https://site.flo-dolc.42.fr`.

### Portainer (Docker Management)

Portainer provides visualization and management of the Docker environment. It mounts the host's `/var/run/docker.sock` to interact with the Docker daemon directly and is accessible via `https://portainer.flo-dolc.42.fr`.

### Uptime Kuma (Monitoring)

Uptime Kuma is a Node.js application built from source that monitors the health and uptime of all services. It periodically pings the HTTP endpoints of the other containers and generates uptime graphs. Access it via `https://kuma.flo-dolc.42.fr`.

## Directory & File Structure

```text
srcs/
├── docker-compose.yml       # Service orchestration
├── .env                     # Environment configuration
└── requirements/
    ├── nginx/               # Main Proxy & SSL
    │   ├── Dockerfile
    │   └── conf/
    ├── mariadb/             # Database
    │   ├── Dockerfile
    │   └── tools/
    ├── wordpress/           # CMS App
    │   ├── Dockerfile
    │   └── tools/
    └── bonus/
        ├── redis/           # Cache
        ├── ftp/             # File Transfer
        ├── adminer/         # DB GUI
        ├── website/         # Static Site
        ├── portainer/       # Infrastructure GUI
        └── uptime-kuma/     # Monitoring
```

## Volumes and Persistence

Data persistence is managed through Docker Named Volumes, ensuring data survives container restarts or rebuilds.

| Volume Name        | Mounted Path     | Purpose                                                                                                |
| ------------------ | ---------------- | ------------------------------------------------------------------------------------------------------ |
| `wp-data`          | `/var/www/html`  | Stores WordPress core files, themes, and plugins. Shared between WordPress, NGINX, and FTP containers. |
| `db-volume`        | `/var/lib/mysql` | Stores raw MariaDB database files.                                                                     |
| `portainer_data`   | `/data`          | Stores Portainer configuration and user data.                                                          |
| `uptime-kuma-data` | `/app/data`      | Stores monitoring history and configuration for Uptime Kuma.                                           |

## Secrets Management

The project uses Docker secrets to securely manage sensitive credentials. Passwords are stored in individual files in the `secrets/` directory at the project root:

- `db_root_password.txt` - MariaDB root password
- `db_password.txt` - MariaDB user password
- `wp_admin_password.txt` - WordPress admin password
- `wp_user_password.txt` - WordPress editor user password
- `ftp_password.txt` - FTP user password

These secrets are mounted as files inside containers at runtime and are never exposed in environment variables or logs.

## Build and Deployment

The project is controlled via a Makefile located at the root:

- `make`: Creates the data directories on the host (`~/data/...`), builds the Docker images, and starts the network.
- `make down`: Stops all containers and removes the network.
- `make clean`: Stops containers and removes all images and volumes, effectively resetting the project to a clean state.
- `make fclean`: Complete cleanup including volumes and data directories.
- `make re`: Full rebuild from scratch.
