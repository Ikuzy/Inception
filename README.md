# Project Documentation
*This documentation provides a comprehensive understanding of the project, demonstrating the application of containerization concepts, created by **ozouine**.*

---

## 📦 What Is Docker?

*"Docker is an open platform for developing, shipping, and running applications, which enables you to separate your applications from your infrastructure so you can deliver software quickly..."¹*

Containers are the core aspect of this technology. Rather than using a virtual machine with a complete OS installation—which can lead to resource exhaustion and time consumption—containers already use the kernel of the host machine and only require the necessary dependencies and libraries to function.

---

## ✨ Benefits

### 🚀 Portability
No more "it works on my machine" problems. Docker containers run consistently across different environments.

### ⚡ Efficiency
- **Lower Resource Usage**: Containers share the host OS kernel
- **Faster Startup**: Boot in seconds instead of minutes
- **Lightweight**: Significantly smaller footprint than VMs

### 🛡️ Isolation
Docker uses advanced techniques to isolate containers, even when they share the same memory space. Through kernel namespaces:

*"...Namespaces provide the first and most straightforward form of isolation. Processes running within a container cannot see, and even less affect, processes running in another container, or in the host system..."²*


### 📈 Scalability
Perfect for microservices architecture, where a failing service doesn't compromise the entire application.

---

## 📝 Dockerfile

*"...A Dockerfile is a text file containing instructions for building your source code..."³*

It provides automation to create a Docker Image—a layered product designed to set up and ensure the service works correctly within the container.

---

## 🎼 Docker Compose

In simple terms, Docker Compose is responsible for the communication and management of multiple Docker containers. It implements:
- **Networking**: Creates networks for inter-container communication
- **Volumes**: Persistent data storage
- **Service orchestration**: Manages service dependencies and startup order

---

## 🌐 Docker Network

Allows container networking. Since containers are isolated in memory, a network is needed for communication using defined ports.

### Why Custom Bridge Network?
- **DNS Resolution**: Containers can reach each other by name
- **Isolation**: Separated from default bridge network
- **Security**: No direct host network access
- **Control**: Custom subnet and gateway configuration

### Docker Network vs Host Network

| Network Mode | Description | Use Case | Isolation |
|--------------|-------------|----------|-----------|
| **Bridge (default)** | Isolated internal network with NAT | Default for containers | ✅ Full |
| **Host** | Shares host's network stack | Performance-critical apps | ❌ None |
| **Custom Bridge** | User-defined isolated network | Multi-container apps | ✅ Full |
| **None** | No networking | Completely isolated tasks | ✅ Maximum |

---

## 💾 Docker Volume

*"Volumes are persistent data stores for containers, created and managed by Docker..."⁴*

Volumes provide a means to preserve data from being erased, ranging from user uploads to themes and preferences. Multiple implementation options are available for data storage.

### Docker Volumes vs Bind Mounts

| Feature | Docker Volumes | Bind Mounts |
|---------|---------------|-------------|
| **Management** | Managed by Docker | Direct host path |
| **Location** | `/var/lib/docker/volumes/` | Anywhere on host |
| **Portability** | High (Docker handles paths) | Low (hardcoded paths) |
| **Performance** | Optimized | Depends on host FS |
| **Backup** | Easy with Docker tools | Manual process |
| **Security** | Docker-controlled permissions | Host filesystem permissions |

---

## 🔒 Security

Despite container isolation, there are multiple potential security vulnerabilities, ranging from HTTP protocol penetration to password leakage through environment variables.

### Password Security

Docker implements **Docker Secrets**, which requires passwords to be stored in a single file, then provided to the `/run/secrets/` directory with maximum security, instead of being in an environment file that gets served to each container.

| Feature | Docker Secrets | Environment Variables |
|---------|----------------|----------------------|
| **Security** | Encrypted at rest and in transit | Visible in `docker inspect` |
| **Storage** | In-memory tmpfs only | Stored in container config |
| **Visibility** | Only to authorized services | Visible to all processes |
| **Best For** | Passwords, API keys, certificates | Configuration, non-sensitive data |
| **Example** | Database passwords | Domain names, ports |

### HTTPS Protocol

Since NGINX is the web server responsible for HTTPS requests, and given the history of cyber threats, **TLS (Transport Layer Security)** was developed to secure communications.

| TLS Version | Year | Status | Key Features | Security | Browser Support | Deprecated |
|-------------|------|--------|--------------|----------|----------------|------------|
| **SSL 3.0** | 1996 | ❌ **DEAD** | First widely used, flawed design | ❌ **Broken** | None | **YES** (2015) |
| **TLS 1.0** | 1999 | ❌ **DEPRECATED** | SSL 3.0 upgrade, RC4, MD5 hash | ❌ **Vulnerable** | Disabled by default | **YES** (2021) |
| **TLS 1.1** | 2006 | ❌ **DEPRECATED** | Protection against CBC attacks | ⚠️ **Weak** | Disabled by default | **YES** (2021) |
| **TLS 1.2** | 2008 | ✅ **SECURE** | AEAD ciphers, SHA-256, GCM mode | ✅ **Strong** | 99.9% | **NO** |
| **TLS 1.3** | 2018 | ✅ **RECOMMENDED** | 0-RTT, modern ciphers only, forward secrecy | ✅ **Strongest** | 98%+ | **NO** |

---

## 🏗️ Docker Engine Architecture

```text
┌─────────────────────────────────────────────────────────────────────────┐
│                            HOST SYSTEM                                  │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                         │
│  ┌──────────────────┐        IPC/TCP        ┌─────────────────────────┐ │
│  │   Docker CLI     │◀─────────────────────▶│    Docker Daemon        │ │
│  │   (Client)       │      (JSON/REST)      │    (Server - dockerd)   │ │
│  │                  │                       │                         │ │
│  │  • Go binary     │                       │  • Persistent process   │ │
│  │  • Commands:     │                       │  • Manages:             │ │
│  │     docker run   │                       │    - Containers         │ │
│  │     docker ps    │                       │    - Images             │ │
│  │     docker build │                       │    - Networks           │ │
│  │                  │                       │    - Volumes            │ │
│  └────────┬─────────┘                       └───────────┬─────────────┘ │
│           │                                            │                │
│           │  ┌─────────────────────────────────────────┘                │
│           │  │                                                          │
│           ▼  ▼                                                          │
│  ┌─────────────────┐                                                    │
│  │ Communication   │                                                    │
│  │  Channel:       │                                                    │
│  │                 │                                                    │
│  │  Option 1:      │          Option 2:                                 │
│  │  ┌──────────┐   │          ┌──────────┐                              │
│  │  │ Unix     │   │          │ TCP      │                              │
│  │  │ Socket   │   │          │ Socket   │                              │
│  │  │ /var/run/│   │          │ 0.0.0.0: │                              │
│  │  │ docker.  │   │          │ 2375     │                              │
│  │  │ sock     │   │          │          │                              │
│  │  └──────────┘   │          └──────────┘                              │
│  │                 │                                                    │
│  └─────────────────┘                                                    │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
```

### Docker CLI

The Docker CLI (Command-Line Interface) is where users interact with Docker using commands to start and stop services, inspect volumes, debug, and more. It communicates with the Docker Daemon using either a UNIX socket or a TCP connection.
- Written in Go
- Sends commands via JSON/REST API
- Primary interface for Docker operations

**Key features:**
- Written in Go
- Sends commands via JSON/REST API
- Primary interface for Docker operations

### Docker Daemon

The Docker Daemon (`dockerd`) is the persistent background service that:
- Listens for Docker API requests
- Manages Docker objects (containers, images, networks, volumes)
- Handles container lifecycle
- Communicates with container runtime (containerd)

**Communication methods:**
- **Unix Socket** (`/var/run/docker.sock`): Default, local-only access
- **TCP Socket** (port 2375/2376): Remote access (requires proper security)

### Container Creation Flow

```text
┌─────────────────────────────────────────────────────────────────────────┐
│                    USER EXECUTES COMMAND                                │
│                    $ docker run nginx                                   │
└────────────────────────────┬────────────────────────────────────────────┘
                             │
                             ▼
┌─────────────────────────────────────────────────────────────────────────┐
│                         Docker CLI                                      │
│                                                                         │
│  • Parses command                                                       │
│  • Sends API request to daemon                                          │
└────────────────────────────┬────────────────────────────────────────────┘
                             │
                             ▼
┌─────────────────────────────────────────────────────────────────────────┐
│                      Docker Daemon (dockerd)                            │
│                                                                         │
│  1. Pulls image if not present                                          │
│  2. Creates container configuration                                     │
│  3. Sets up networking                                                  │
│  4. Prepares volumes                                                    │
│  5. Calls containerd                                                    │
└────────────────────────────┬────────────────────────────────────────────┘
                             │
                             ▼
┌─────────────────────────────────────────────────────────────────────────┐
│                       containerd                                        │
│                   (Container Supervisor)                                │
│                                                                         │
│  • Manages container lifecycle                                          │
│  • Handles image transfer from daemon                                   │
│  • Supervises runc                                                      │
│  • Manages container snapshots                                          │
└────────────────────────────┬────────────────────────────────────────────┘
                             │
                             ▼
┌─────────────────────────────────────────────────────────────────────────┐
│                       containerd-shim                                   │
│                                                                         │
│  • Keeps container running if containerd restarts                       │
│  • Reports exit status                                                  │
│  • Manages STDIO streams                                                │
└────────────────────────────┬────────────────────────────────────────────┘
                             │
                             ▼
┌─────────────────────────────────────────────────────────────────────────┐
│                           runc                                          │
│                    (OCI Runtime)                                        │
│                                                                         │
│  1. Creates namespaces                                                  │
│  2. Sets up cgroups (resource limits)                                   │
│  3. Configures root filesystem (overlay/bind mounts)                    │
│  4. Applies security profiles (AppArmor/SELinux)                        │
│  5. Executes container process                                          │
│  6. Exits (shim takes over)                                             │
└────────────────────────────┬────────────────────────────────────────────┘
                             │
                             ▼
┌─────────────────────────────────────────────────────────────────────────┐
│                    RUNNING CONTAINER                                    │
│                                                                         │
│  ┌───────────────────────────────────────────┐                          │
│  │  Isolated Process with:                   │                          │
│  │  • Own PID namespace                      │                          │
│  │  • Own network stack                      │                          │
│  │  • Own filesystem view                    │                          │
│  │  • Resource limits (CPU, memory)          │                          │
│  │  • Security constraints                   │                          │
│  └───────────────────────────────────────────┘                          │
└─────────────────────────────────────────────────────────────────────────┘
```
---

## 📋 Service Overview

This infrastructure consists of the following services:

### Core Services

- **NGINX** - Secure web server (HTTPS only, TLSv1.2/1.3)
- **WordPress** - Content management system with PHP-FPM
- **MariaDB** - Database server for WordPress data
- **Redis** - Cache service for improved performance

### Bonus Services

- **FTP Server** - File upload/download service
- **Adminer** - Database management interface
- **Static Website** - Custom landing page
- **cAdvisor** - Container performance monitoring

---

## 🔗 Service Architecture & Communication Flow

```text
                                    INTERNET
                                       │
                                       │ HTTPS (443)
                                       │ TLS 1.2/1.3
                                       ▼
┌──────────────────────────────────────────────────────────────────────────┐
│                              HOST SYSTEM                                 │
│  ┌────────────────────────────────────────────────────────────────────┐  │
│  │                      Docker Bridge Network                         │  │
│  │                        (inception-net)                             │  │
│  │                                                                    │  │
│  │  ┌─────────────────────────────────────────────────────────────┐   │  │
│  │  │                         NGINX                               │   │  │
│  │  │                    (Reverse Proxy)                          │   │  │
│  │  │                                                             │   │  │
│  │  │  • Port 443 (HTTPS)                                         │   │  │
│  │  │  • SSL/TLS Termination                                      │   │  │
│  │  │  • Routes requests to backend services                      │   │  │
│  │  └──────────────┬────────────────┬─────────────┬───────────────┘   │  │
│  │                 │                │             │                   │  │
│  │                 │                │             │                   │  │
│  │      ┌──────────▼──────┐  ┌──────▼──────┐  ┌───▼───────────┐       │  │
│  │      │   WordPress     │  │   Adminer   │  │ Static Site   │       │  │
│  │      │   (PHP-FPM)     │  │             │  │               │       │  │
│  │      │                 │  │  Port 8080  │  │  Port 80      │       │  │
│  │      │  • Port 9000    │  │             │  │               │       │  │
│  │      │  • FastCGI      │  │  Database   │  │  HTML/CSS/JS  │       │  │
│  │      └────┬─────┬──────┘  │  Manager    │  │               │       │  │
│  │           │     │         └──────┬──────┘  └───────────────┘       │  │
│  │           │     │                │                                 │  │
│  │           │     │                │                                 │  │
│  │           │     └────────────────┼─────────────────┐               │  │
│  │           │                      │                 │               │  │
│  │           │                      │                 │               │  │
│  │      ┌────▼──────────┐      ┌────▼─────────┐  ┌────▼─────────┐     │  │
│  │      │    Redis      │      │   MariaDB    │  │  FTP Server  │     │  │
│  │      │    (Cache)    │      │  (Database)  │  │              │     │  │
│  │      │               │      │              │  │  Port 21     │     │  │
│  │      │  Port 6379    │      │  Port 3306   │  │  Port 21000  │     │  │
│  │      │               │----->│              │  │              │     │  │
│  │      │  • Object     │      │  • WordPress │  │  • FTPS      │     │  │
│  │      │    Caching    │      │    Data      │  │  • Upload/   │     │  │
│  │      │  • Session    │      │  • Users     │  │    Download  │     │  │
│  │      │    Storage    │      │  • Posts     │  │              │     │  │
│  │      └───────────────┘      └──────────────┘  └──────────────┘     │  │
│  │                                                                    │  │
│  │  ┌─────────────────────────────────────────────────────────────┐   │  │
│  │  │                       cAdvisor                              │   │  │
│  │  │                  (Monitoring Service)                       │   │  │
│  │  │                                                             │   │  │
│  │  │  • Port 8081                                                │   │  │
│  │  │  • Monitors all containers                                  │   │  │
│  │  │  • Resource usage metrics                                   │   │  │
│  │  │  • Performance analytics                                    │   │  │
│  │  └─────────────────────────────────────────────────────────────┘   │  │
│  │                                                                    │  │
│  └────────────────────────────────────────────────────────────────────┘  │
│                                                                          │
│  ┌────────────────────────────────────────────────────────────────────┐  │
│  │                      Docker Volumes                                │  │
│  │                                                                    │  │
│  │  • wordpress-data  → /var/www/html (WordPress files)               │  │
│  │  • mariadb-data    → /var/lib/mysql (Database files)               │  │
│  │  • nginx-certs     → /etc/nginx/ssl (SSL certificates)             │  │
│  └────────────────────────────────────────────────────────────────────┘  │
└──────────────────────────────────────────────────────────────────────────┘
```
---

1. (https://docs.docker.com/get-started/docker-overview/)
2. (https://docs.docker.com/engine/security/#kernel-namespaces)
3. (https://docs.docker.com/build/concepts/dockerfile/)
4. (https://docs.docker.com/engine/storage/volumes/)


## 📚 References
### 📖 Books & Documentation
- **Docker Deep Dive: Zero to Docker in a single book**  
  *by Nigel Poulton*

### 🔐 Security & Standards
- [Docker Swarm Secrets](https://docs.docker.com/engine/swarm/secrets/)
- [TLS 1.3 Specification (RFC 8446)](https://datatracker.ietf.org/doc/html/rfc8446)
- [TLS 1.2 Specification (RFC 5246)](https://datatracker.ietf.org/doc/html/rfc5246)

### 🛠️ Core Technologies
- [containerd - Container Runtime](https://github.com/containerd/containerd)
- [NGINX - Configuring HTTPS Servers](https://nginx.org/en/docs/http/configuring_https_servers.html)
- [PHP-FPM Installation Guide](https://www.php.net/manual/en/install.fpm.php)
- [Redis Developer Tools](https://redis.io/docs/latest/develop/tools/)

### 🗄️ Database & CMS
- [WordPress Official Docker Image](https://hub.docker.com/_/wordpress)
- [MariaDB Documentation](https://mariadb.org/documentation/)

### 🔧 Additional Tools
- [vsftpd - Secure FTP Server](https://security.appspot.com/vsftpd.html)
- [Adminer - Database Management](https://www.adminer.org/en/)
- [cAdvisor - Container Monitoring](https://github.com/google/cadvisor)

---
