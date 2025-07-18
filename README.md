# 🚪 API Gateway with NGINX + Docker + GitHub Actions 🚀

This project provides a fully containerized **API Gateway** using **NGINX** to route requests to multiple backend services. It's designed to work both **locally** and **in production** on an **Ubuntu EC2 instance**, with CI/CD via **GitHub Actions** and secure secrets handling via **GitHub Secrets**.

---

## 📦 Features

- 🔁 Reverse proxy for multiple backend services
- 🐳 Runs fully in Docker
- 🚀 Auto-deploys to EC2 using GitHub Actions
- 🔐 Environment variables managed via GitHub Secrets
- 🌐 Supports both local and remote services

---

## 📁 Project Structure

```

api-gateway/
├── nginx/
│   ├── Dockerfile              # Builds the NGINX container
│   ├── default.template.conf   # NGINX config template using env vars
│   └── entrypoint.sh           # Generates nginx.conf from template
├── docker-compose.yml          # Compose setup for the gateway
└── .github/workflows/
└── deploy.yml              # GitHub Actions workflow

````

---

## ⚙️ How it Works

1. `default.template.conf` uses environment variables like `SERVICE1_HOST` and `SERVICE1_PORT`.
2. `entrypoint.sh` uses `envsubst` to generate a valid `nginx.conf` at runtime.
3. Docker Compose builds and runs the container using those variables.
4. GitHub Actions pushes the code to your EC2, installs Docker if necessary, and runs the gateway using `docker-compose`.

---

## 🧪 Local Development

> Requirements: Docker + Docker Compose

1. Create a `.env` file (this file is **.gitignored**):

```env
SERVICE1_HOST=host.docker.internal
SERVICE1_PORT=3001
SERVICE2_HOST=host.docker.internal
SERVICE2_PORT=3002
SERVICE3_HOST=host.docker.internal
SERVICE3_PORT=3003
SERVICE4_HOST=host.docker.internal
SERVICE4_PORT=3004
````

2. Run:

```bash
docker-compose up --build -d
```

3. Send requests to:

```
http://localhost/auth/login → routed to one of the backends
```

---

## ☁️ Production Deployment (EC2)

1. Setup an Ubuntu EC2 instance with SSH access
2. Add the following **Secrets** in your GitHub repo:

| Name            | Description                     |
| --------------- | ------------------------------- |
| `EC2_HOST`      | Public IP or domain of EC2      |
| `EC2_USER`      | SSH username (e.g., ubuntu)     |
| `EC2_SSH_KEY`   | SSH private key (no passphrase) |
| `SERVICE1_HOST` | IP of backend 1                 |
| `SERVICE1_PORT` | Port of backend 1               |
| `SERVICE2_HOST` | IP of backend 2                 |
| `SERVICE2_PORT` | Port of backend 2               |
| `SERVICE3_HOST` | IP of backend 3                 |
| `SERVICE3_PORT` | Port of backend 3               |
| `SERVICE4_HOST` | IP of backend 4                 |
| `SERVICE4_PORT` | Port of backend 4               |

3. Push to `main` branch:

```bash
git push origin main
```

4. GitHub Actions will:

* Copy your files to EC2
* Install Docker & Docker Compose (if missing)
* Run your container with `docker compose` and injected env vars

---

## 🔍 Routes Example

```
Incoming → Proxy to
----------------------------
/auth/login → SERVICE1_HOST
/other/path → SERVICE2_HOST
/random/api → SERVICE3_HOST
/anything/... → SERVICE4_HOST
```

All requests go through `/` and are load-balanced if needed via `upstream` block.

---

## 🛠️ Useful Commands

```bash
# Check container logs
docker logs api-gateway

# Stop and remove everything
docker-compose down
```

---

## 🤖 GitHub Actions Workflow Highlights

* Uses `webfactory/ssh-agent` to load your SSH key
* Uses `rsync` to copy files to EC2
* SSHs into EC2 and runs Docker Compose with your env vars
* Auto installs Docker and Docker Compose if missing

---

## 🧼 Cleanup

To remove everything from the server:

```bash
ssh ubuntu@<EC2_HOST>
cd ~/api-gateway
docker compose down
```

---

## 🧠 Tips

* If you’re running services locally, use `host.docker.internal` inside `.env`
* Make sure all backends listen on `0.0.0.0` and not `localhost`
* You can scale the upstream services or route specifically with NGINX logic

---

## 🧾 License

MIT License © 2025

---

Happy proxying! 🎉
