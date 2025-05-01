FROM ubuntu:24.04

# Install dependencies
RUN apt-get update && apt-get install -y \
    jq \
    git \
    bash \
    coreutils \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy script and env file
COPY backup.sh .
COPY .env .

# Make the script executable
RUN chmod +x /app/backup.sh

# Create backup directory with universal permissions
RUN mkdir -p /app/backups && chmod -R 755 /app/backups

# Run the backup script
ENTRYPOINT ["/app/backup.sh"]
