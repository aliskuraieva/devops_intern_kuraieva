# Use the base Ubuntu image
FROM ubuntu:24.04

# Install required packages
RUN apt-get update && apt-get install -y \
    jq \
    git \
    bash \
    && rm -rf /var/lib/apt/lists/*

# Set the working directory
WORKDIR /backup

# Copy the script file into the container
COPY ./backup.sh /backup/

# Make the script executable
RUN chmod +x /backup/backup.sh

# Set the command to be executed when the container runs
ENTRYPOINT ["/backup/backup.sh"]
