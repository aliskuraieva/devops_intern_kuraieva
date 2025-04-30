FROM ubuntu:24.04

RUN apt-get update && apt-get install -y \
    jq \
    git \
    bash \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY backup.sh .

RUN chmod +x backup.sh

ENTRYPOINT ["/app/backup.sh"]
