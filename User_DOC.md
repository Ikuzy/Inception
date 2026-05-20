# User Documentation

*This infrastructure provides a complete WordPress hosting environment, created by **ozouine**.*

## 🎯 Quick Start Commands

### Start the Containers
```bash
make up
```
Starts all services in detached mode. Services will be ready in a few seconds.

### Stop the Containers
```bash
make down
```
Gracefully stops all running services while preserving data.

### Clean Volumes
```bash
make clean
```
Stops services and removes all Docker volumes (database and WordPress files will be deleted).

### Complete Cleanup
```bash
make fclean
```
Performs a full cleanup:
- Stops all containers
- Removes all volumes
- Removes all Docker images
- Removes networks
- Prunes Docker system

### Clean Data Directories
```bash
make clean_data
```
**⚠️ WARNING**: Permanently deletes all data in `/home/ozouine/data/`
- Requires confirmation (type `YES`)
- Cannot be undone
- Use with extreme caution

### Rebuild Everything
```bash
make re
```
Complete rebuild process:
1. Cleans all data directories (with confirmation)
2. Starts fresh containers with clean state



## 🚀 Quick Access Guide

It is recommended to access the services in the following order:

### 1. Static Page - Your Gateway
**URL**: `https://static.ozouine.42.fr`

This is your main entry point, featuring a beautifully designed landing page with three redirection options to access all project services.

---

### 2. WordPress Website
**Access**: Click the first option on the static page, or directly visit `https://ozouine.42.fr`

The WordPress interface provides a full-featured content management system where you can:
- Create and publish content
- Manage your website
- Customize themes and plugins
- Enjoy a complete blogging platform

**Login Credentials**:
- Admin panel: `https://ozouine.42.fr/wp-admin`
- Username: Found in `.env` file
- Password: Located in `secrets/wordpress_admin_password.txt`

---

### 3. Adminer - Database Management
**Access**: Click the second option on the static page, or visit `https://static.ozouine.42.fr/adminer/`

Adminer provides a powerful web interface for managing your MariaDB database.

#### Login Information:
| Field | Value | Location |
|-------|-------|----------|
| **System** | `MySQL` | *(MariaDB uses MySQL-compatible protocol)* |
| **Server** | `mariadb` | *(Service container name)* |
| **Username** | `MYSQL_USER` | Found in `.env` file |
| **Password** | `MYSQL_PASSWORD` | Found in `secrets/db_password.txt` |
| **Database** | `MYSQL_DATABASE` | Found in `.env` file |

Once logged in, you can:
- View and edit database tables
- Execute SQL queries
- Import and export data
- Manage database structure

---

### 4. cAdvisor - Container Monitoring
**Access**: Click the third option on the static page, or visit `https://static.ozouine.42.fr:8888/`

cAdvisor (Container Advisor) is a powerful monitoring tool developed by Google that provides real-time insights into your Docker containers.

**Features**:
- Live performance metrics
- CPU and memory usage
- Network statistics
- Container health monitoring
- Resource utilization graphs

*It's that simple!*

---

## 📂 Using FTP Service

Access your WordPress files remotely via FTP.

### Connection Details
- **Host**: `ozouine.42.fr` or `localhost`
- **Port**: `21`
- **Username**: `www-data`
- **Password**: Found in `secrets/vsftp_password.txt`

### Quick FTP Commands

#### List Files
```bash
> curl -l ftp://localhost/ --user "www-data:$(cat secrets/vsftp_password.txt)"
```

#### Upload a File
```bash
> curl -T <filename> ftp://localhost/wp-content/uploads/myfile.txt \
  --user "www-data:$(cat secrets/vsftp_password.txt)"
```

#### Download a File
```bash
> curl -o <filename> ftp://localhost/somefile.txt \
  --user "www-data:$(cat secrets/vsftp_password.txt)"
```

#### Delete a File
```bash
> curl -Q "DELE <filename>" ftp://localhost/ \
  --user "www-data:$(cat secrets/vsftp_password.txt)"
```

---

### Check All Containers
```bash
> docker ps
```
*Expected: 7 running containers*

#### NGINX
```text
Sadly, Using The Self-Signed Certification, The Only Proof That NGinx Works Is The Fact That The Website Is Served.
```

#### MariaDB
```bash
> docker exec mariadb /usr/bin/mariadb-admin -u root -p$(cat /secrets/db_root_password.txt) ping
# Expected: mysqld is alive
```

#### Redis
```bash
> docker exec redis redis-cli PING
# Expected: PONG
```

#### WordPress
```bash
> docker exec wordpress wp db check --allow-root --path=/var/www/html
# Expected: Success: Database checked.
```

---

## 🔧 Common Operations

### View Logs
```bash
# All services
> docker-compose -f srcs/docker-compose.yml logs -f

# Specific service
> docker logs -f wordpress
```

### Access a Container
```bash
> docker exec -it wordpress sh
```


