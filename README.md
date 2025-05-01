# 🛠️ DevOps - Task 1: Backup Script

This project includes a Bash script to automate GitHub repository backups. It creates versioned `.tar.gz` archives, logs metadata in JSON, and keeps only the latest backups based on configuration.

---

## 📁 Project Structure

```
.
├── backup.sh         # Main bash script
├── .env              # Environment variables (created from .env.sample)
├── .env.sample       # Template for configuration
├── .gitignore        # Ignores .env and other sensitive files
└── README.md         # Documentation
```

---

## ⚙️ Requirements

Make sure you have installed:

- `git`
- `jq` (for JSON parsing)
- `bash`
- SSH access to your GitHub repository

Install `jq` (if needed):

```bash
sudo apt update
sudo apt install jq
```

---

## 📥 Setup

1. Clone the repository:

```bash
git clone git@github.com:aliskuraieva/devops_intern_kuraieva.git
cd devops_intern_kuraieva
```

2. Copy the sample environment file:

```bash
cp .env.sample .env
```

3. Edit the `.env` file and fill in your values:

```env
REPO_URL=git@github.com:your_user/your_repo.git
BACKUP_DIR=/backup
VERSION_FILE=/backup/versions.json
```

---

## 🚀 Running the Script with Docker (For Task)

For this task, you need to run the script using Docker. Follow these steps:

1. **Create a Dockerfile** (if not done yet).

2. **Build the Docker Image:**

```bash
docker build -t backup-script .
```

3. **Run the Docker Container:**

Make sure to create a backup folder on your host:

```bash
mkdir -p ~/backup
```

Ensure the folder is accessible with the correct permissions. To allow read and write access for all users, the following commands can be used:

1. **For Docker Container:**
   In the Dockerfile, the backup folder `/app/backups` is created with universal permissions to ensure that the container can access it:

   ```dockerfile
   RUN mkdir -p /app/backups && chmod -R 777 /app/backups
   ```

2. **For Host Machine (e.g., Windows, Linux):**
   Ensure that the local `~/backup` folder (on the host machine) has universal access, so that Docker can read and write files there. Run the following command:

   ```bash
   sudo chmod -R 777 ~/backup
   ```

   This ensures that any process, regardless of user, can access the backup folder both inside the container and on the host machine.

These steps can be done automatically without manual intervention during Docker build and run, ensuring that the folder permissions are set correctly for all users.

Then run the following command to execute the backup:

```bash
docker run --rm -v "$HOME/.ssh:/root/.ssh:ro" -v "$HOME/backup:/app/backups" -v "$(pwd)/.env:/app/.env" backup-script --max-runs 3 --max-backups 5
```

### Explanation of Docker Commands:

- `docker build -t backup-script .`: Builds the Docker image from the current directory using the provided Dockerfile.
- `docker run ...`: Runs the backup script in Docker with access to environment variables and SSH key.
- Mounting `~/backup` ensures files are created on the host with your user permissions (not root).

---

## 📂 versions.json Example

```json
[
  {
    "version": "1.0.1",
    "date": "2025-04-23",
    "filename": "your-repo_1.0.1.tar.gz",
    "size": "382944"
  }
]
```

---

## ❗ Notes

- **Never commit your `.env` file to Git!**
- Ensure your SSH key is added to GitHub.
- If you get `Permission denied (publickey)`, check your SSH access.
- **Important:** If you use SSH to clone repositories, you must either follow the instructions in this README to correctly prepare your SSH key or the setup should be handled automatically in the bash script or Dockerfile without manual intervention.

---

## 🔑 SSH Key Setup Instructions

If you want to use SSH access inside Docker, you must:

1. Generate a new SSH key if you don't have one:

```bash
ssh-keygen -t ed25519 -C "your_email@example.com"
```

2. Add the public SSH key to your GitHub account (Settings → SSH and GPG keys → New SSH Key).

Copy the public key:

```bash
cat ~/.ssh/id_ed25519.pub
```

3. When running the Docker container, mount your `.ssh` directory:

```bash
docker run --rm -v "$HOME/.ssh:/root/.ssh:ro" -v "$HOME/backup:/app/backups" -v "$(pwd)/.env:/app/.env" backup-script --max-runs 3 --max-backups 5
```

This setup ensures your backup functionality works securely via SSH inside Docker.
