_This project has been created as part of the 42 curriculum by flo-dolc._

# Inception

This project is part of the 42 curriculum and focuses on system administration through Docker. The goal is to set up a complete infrastructure using Docker containers, implementing a LEMP stack (Linux, NGINX, MariaDB, PHP-FPM) along with several administration and monitoring tools. Each service runs in its own Alpine Linux container.

## Overview

The infrastructure consists of two main parts:

### Core Services

- NGINX as the reverse proxy and SSL termination point (port 443, TLSv1.2/1.3)
- WordPress with PHP-FPM for content management
- MariaDB as the database backend
- Persistent volumes for database and WordPress files
- Isolated Docker networks for security

### Additional Services

- Redis for WordPress object caching
- vsftpd for FTP access to WordPress files
- Adminer for database management through a web interface
- A static website served by a separate NGINX instance
- Portainer for Docker container management
- Uptime Kuma for service monitoring

## Requirements

You'll need the following installed on your system:

- Docker Engine 20.10.13 or later
- Docker Compose v2.0.0 or later
- Make
- A Linux distribution (Debian, Ubuntu, or Alpine)

## Getting Started

Clone this repository and navigate to the project directory:

```bash
git clone <repository_url> inception
cd inception
```

Set up your environment variables by creating a `.env` file in the `srcs/` directory. You'll also need to create password files in the `secrets/` directory. Refer to `USER_DOC.md` for the required variables and secret files.

Build and start the infrastructure:

```bash
make
```

Once everything is running, open your browser and go to `https://flo-dolc.42.fr`. You'll need to configure your hosts file first (see the network configuration section in `USER_DOC.md`).

## Available Commands

The Makefile provides several commands for managing the infrastructure:

- `make` - Build all images and start containers
- `make down` - Stop containers and remove networks
- `make clean` - Stop containers and remove images (keeps volumes)
- `make fclean` - Complete cleanup including volumes and data directories
- `make re` - Full rebuild from scratch

## Documentation

For detailed information about configuration and usage, see:

- `USER_DOC.md` - User guide and configuration instructions
- `DEV_DOC.md` - Technical architecture and implementation details
