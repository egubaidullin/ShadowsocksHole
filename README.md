# ShadowsocksHole = Shadowsock+Pihole+Unbound+Installer Script

## What is it
Shadowsockshole is a repository for deploying a Shadowsocks encrypted tunnel along with Unbound DNS server and Pi-hole ad blocker using Docker containers. It allows accessing blocked internet resources by routing DNS queries and traffic through an encrypted Shadowsocks tunnel.

## Description
Shadowsockshole is a Docker-based solution for deploying a Shadowsocks tunnel along with Pi-hole and Unbound DNS server. This setup enables access to blocked resources by bypassing censorship.

### Components
- `install.sh`: Installation script
- `docker-compose.yml`: Docker container descriptions
- `unbound/unbound.conf`: Unbound DNS server configuration
- `README.md`: This documentation file

## Installation
To install, run the `install.sh` script:
1. Checks and installs Docker and Docker Compose if needed
2. Creates `.env` file for environment variables
3. Generates a random PASSWORD and saves it to `.env`
4. Writes the current timezone `TZ` to `.env`
5. Starts `docker-compose` to deploy containers

After installation, save the generated PASSWORD from the `.env` file.

## Usage
After running the installation script, containers are deployed using `docker-compose`.

To check the IP address of the Shadowsocks server, use:
```bash
curl -s checkip.dyndns.org | sed -e 's/.*Current IP Address: //' -e 's/<.*$//'
```
Configure your browser or app with the following settings:

SOCKS5 proxy IP: [Shadowsocks server IP]
Port: 1080
Use the saved PASSWORD.

## Components

docker-compose.yml
Describes containers:

- **unbound**: Unbound DNS server using configuration from unbound/unbound.conf
- **pihole**: Pi-hole container for ad blocking using Unbound as upstream DNS server
- **shadowsocks**: Shadowsocks tunnel container
    - Starts automatically on docker-compose up
    - Uses 10.2.0.50 address in the container network
    - Opens ports 8388 TCP and UDP for tunneling traffic
    - Uses volumes with sha:sha1 parameter for data integrity
    - Uses Pi-hole and Unbound as DNS servers

## unbound/unbound.conf
**Unbound DNS server configuration:**

- Caches query responses with TTL up to 86400 seconds
- Listens for queries from local networks and Pi-hole on port 53
- Enables privacy settings: query minimization, aggressive negative caching, etc.
- Allows recursive queries only from local networks for security
- Uses DNS over TLS for forwarding queries to upstream servers (commented out)
- Remote control is disabled

This setup allows Unbound to accept queries from the local network, cache responses, and forward the rest via the encrypted SOCKS5 tunnel of Shadowsocks, bypassing blocks.

## Authorship
Gubaidullin Eduard
