# Self-Hosted Matrix & Identity Infrastructure (Quadlet Edition)

A lightweight, high-performance stack hosted on Oracle Cloud Free Tier (Ampere ARM64).  
Hosted at `dariush.dev` using **Tuwunel** (Matrix), **PocketID** (OIDC), and **Uptime Kuma** (Monitoring), orchestrated via **Rootless Podman Quadlets**.

---

## 1. OCI Console Configuration (Oracle Cloud)

### 1.1 Compute Instance

- **Image:** Oracle Linux 9 (aarch64)
- **Shape:** VM.Standard.A1.Flex (4 OCPUs, 24GB RAM recommended)
- **SSH Keys:** Add your public key during creation.

### 1.2 Networking (VCN & Security Lists)

Go to **Virtual Cloud Networks** → [Your VCN] → **Security Lists** → [Default Security List].  
Add these **Ingress Rules**:

| Source         | Protocol | Port Range |
| -------------- | -------- | ---------- |
| `0.0.0.0/0`    | TCP      | 80 (HTTP)  |
| `0.0.0.0/0`    | TCP      | 443 (HTTPS)|

### 1.3 Storage (Block Volume)

1. Create a **Block Volume** (e.g., 50GB or 150GB).
2. Attach it to your instance as **Paravirtualized**.

---

## 2. Server Initialization (SSH)

Log in to your server:

```bash
ssh opc@<YOUR_SERVER_IP>
```

### 2.1 System Updates & Tools

```bash
sudo dnf update -y
sudo dnf install -y git podman vim
```

### 2.2 Firewall (OS Level)

Open ports 80 and 443:

```bash
sudo firewall-cmd --permanent --add-service=http
sudo firewall-cmd --permanent --add-service=https
sudo firewall-cmd --reload
```

### 2.3 Mount Block Volume

Identify volume (usually `/dev/sdb`) and mount to `/mnt/data`:

```bash
# 1. Format (Only if new)
# sudo mkfs.ext4 -L data_volume /dev/sdb1

# 2. Mount
sudo mkdir -p /mnt/data
sudo mount -o defaults /dev/sdb1 /mnt/data
sudo chown -R opc:opc /mnt/data

# 3. Persist in /etc/fstab (Get UUID: lsblk -f)
# UUID=xxxx-xxxx /mnt/data ext4 defaults,noatime,_netdev 0 2
```

---

## 3. Rootless Podman Configuration

### 3.1 Enable Unprivileged Ports

Allow non-root users to bind ports 80 and 443:

```bash
echo "net.ipv4.ip_unprivileged_port_start=80" | sudo tee /etc/sysctl.d/99-rootless-ports.conf
sudo sysctl --system
```

### 3.2 Enable User Lingering (Critical for Quadlets)

Ensure services run at boot without user login:

```bash
sudo loginctl enable-linger $USER
```

---

## 4. Deployment (Quadlets)

### 4.1 Directory Structure

```
/mnt/data/infra/
├── deploy.sh           # Script to sync Quadlets to systemd
├── .env                # Secrets (Not committed)
├── quadlets/           # Source of truth for containers
│   ├── web.network
│   ├── caddy.container
│   ├── pocketid.container
│   ├── kuma.container
│   └── tuwunel.container
└── [app_data_dirs]     # Mapped volumes
```

### 4.2 Setup

1. **Clone Repo:**
    ```bash
    git clone <URL> /mnt/data/infra
    ```

2. **Create `.env`:**
    ```bash
    POCKET_ID_KEY="<BASE64_KEY>"
    ```

3. **Deploy Services:**
    ```bash
    chmod +x deploy.sh
    ./deploy.sh
    ```

4. **Enable Auto-Start:**
    ```bash
    systemctl --user enable caddy pocketid kuma tuwunel
    ```

### 4.3 Service Definitions (Reference)

#### `quadlets/caddy.container`

```ini
[Unit]
Description=Caddy Reverse Proxy
After=network-online.target

[Container]
Image=docker.io/library/caddy:alpine
ContainerName=caddy
Network=web.network
PublishPort=80:80
PublishPort=443:443
Volume=/mnt/data/infra/caddy/Caddyfile:/etc/caddy/Caddyfile:Z
Volume=/mnt/data/infra/caddy/data:/data:Z
Volume=/mnt/data/infra/caddy/config:/config:Z

[Service]
Restart=always

[Install]
WantedBy=default.target
```

#### `quadlets/tuwunel.container`

```ini
[Unit]
Description=Tuwunel Matrix Server
After=network-online.target

[Container]
Image=docker.io/jevolk/tuwunel:main-release-all-aarch64-v8-linux-gnu
ContainerName=tuwunel
Network=web.network
Environment=TUWUNEL_SERVER_NAME=dariush.dev
Environment=TUWUNEL_DATABASE_PATH=/var/lib/tuwunel
Environment=TUWUNEL_DATABASE_BACKEND=sqlite
Environment=TUWUNEL_PORT=8008
Environment=TUWUNEL_ADDRESS=0.0.0.0
Environment=TUWUNEL_MAX_REQUEST_SIZE=20000000
Environment=TUWUNEL_ALLOW_REGISTRATION=false
Volume=/mnt/data/infra/tuwunel:/var/lib/tuwunel:Z

[Service]
Restart=always

[Install]
WantedBy=default.target
```

---

## 5. Federation

**Cloudflare Delegation:**  
Ensure the following are served from the apex (`dariush.dev`):

- `/.well-known/matrix/server`:  
  `{"m.server": "matrix.dariush.dev:443"}`
- `/.well-known/matrix/client`:  
  `{"m.homeserver": {"base_url": "https://matrix.dariush.dev"}}`

---

## 6. Management Cheatsheet

### Status

```bash
systemctl --user status caddy
```

### Logs

```bash
# Via Systemd (Preferred)
journalctl --user -u tuwunel -f

# OR via Podman
podman logs -f tuwunel
```

### Update/Restart

1. Update Quadlet file (if config changed).
2. Run `./deploy.sh`.
3. Restart service:
    ```bash
    systemctl --user restart <service_name>
    ```

### Auto-Update Images

Podman Auto-Update is not configured yet. To update manually:

```bash
podman pull docker.io/jevolk/tuwunel:main-release-all-aarch64-v8-linux-gnu
systemctl --user restart tuwunel
```
