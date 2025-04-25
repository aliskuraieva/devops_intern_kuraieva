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
REPO_URL=git@github.com:yourusername/yourrepo.git
BACKUP_DIR=/path/to/backup/directory
REPO_NAME=your-repo-name
MAX_BACKUPS=5
MAX_RUNS=3
```

4. Make the script executable:

```bash
chmod +x backup.sh
```

---

## 🚀 Running the Script with Docker (For Task)

For this task, you need to run the script using Docker. Follow these steps:

1. **Create a Dockerfile**

2. **Build the Docker Image:**

```bash
docker build -t backup-script .
```

3. **Run the Docker Container:**

```bash
docker run --rm -v "$(pwd)/.env:/backup/.env" backup-script --max-runs 3 --max-backups 5
```

### Explanation of Docker Commands:

- `docker build -t backup-script .`: Builds the Docker image from the current directory using the provided Dockerfile.
- `docker run --rm -v "$(pwd)/.env:/backup/.env" backup-script`: Runs the backup script in a Docker container with the environment variables from your `.env` file.

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

---

## ✅ Verification

1. Create a new `backup` branch.
2. Add and commit all changes:

```bash
git add .
git commit -m "Initial backup script"
```

3. Push to remote:

```bash
git push origin backup
```
