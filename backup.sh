#!/bin/bash

if [[ -f .env ]]; then
    source .env
else
    echo ".env file is missing"
    exit 1
fi

echo "REPO_URL: $REPO_URL"
echo "BACKUP_DIR: $BACKUP_DIR"
echo "VERSION_FILE: $VERSION_FILE"
echo "MAX_BACKUPS: $MAX_BACKUPS"
echo "MAX_RUNS: $MAX_RUNS"

if [[ -z "$REPO_URL" || -z "$BACKUP_DIR" || -z "$VERSION_FILE" ]]; then
    echo "One or more required variables (REPO_URL, BACKUP_DIR, VERSION_FILE) are missing."
    exit 1
fi

mkdir -p "$BACKUP_DIR"

if [ ! -f "$VERSION_FILE" ]; then
    echo "[]" > "$VERSION_FILE"
fi

get_version() {
    local latest_version=$(jq -r '.[0].version' "$VERSION_FILE")

    if [[ "$latest_version" == "null" || ! "$latest_version" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        echo "0.0.1"
        return
    fi

    IFS='.' read -r major minor patch <<< "$latest_version"
    patch=$((patch + 1))

    if [ "$patch" -gt 99 ]; then
        patch=0
        minor=$((minor + 1))
    fi
    if [ "$minor" -gt 99 ]; then
        minor=0
        major=$((major + 1))
    fi

    echo "$major.$minor.$patch"
}

backup() {
    version=$(get_version)
    date=$(date "+%d.%m.%Y")
    filename="${REPO_NAME}_${version}.tar.gz"

    git clone "$REPO_URL" "$BACKUP_DIR/$REPO_NAME"
    tar -czf "$BACKUP_DIR/$filename" -C "$BACKUP_DIR" "$REPO_NAME"
    rm -rf "$BACKUP_DIR/$REPO_NAME"

    size=$(stat -c %s "$BACKUP_DIR/$filename")

    jq --arg version "$version" --arg date "$date" --arg filename "$filename" --arg size "$size" \
       '. |= [{version: $version, date: $date, filename: $filename, size: $size}] + .' "$VERSION_FILE" > tmp.json && mv tmp.json "$VERSION_FILE"

    echo "Backup completed: $filename"
}

if ! [[ "$MAX_RUNS" =~ ^[0-9]+$ ]] || [ "$MAX_RUNS" -le 0 ]; then
    echo "Invalid value for MAX_RUNS. It must be a positive integer."
    exit 1
fi

if ! [[ "$MAX_BACKUPS" =~ ^[0-9]+$ ]] || [ "$MAX_BACKUPS" -le 0 ]; then
    echo "Invalid value for MAX_BACKUPS. It must be a positive integer."
    exit 1
fi

while [[ $# -gt 0 ]]; do
  case $1 in
    --max-runs)
      MAX_RUNS="$2"
      shift 2
      ;;
    --max-backups)
      MAX_BACKUPS="$2"
      shift 2
      ;;
    *)
      echo "Unknown option: $1"
      exit 1
      ;;
  esac
done

for ((i=0; i<MAX_RUNS; i++)); do
    backup
done

if [[ "$MAX_BACKUPS" =~ ^[0-9]+$ ]] && [ "$MAX_BACKUPS" -gt 0 ]; then
    backups=( $(ls -1t "$BACKUP_DIR"/"${REPO_NAME}"_*.tar.gz 2>/dev/null) )
    total=${#backups[@]}
    if (( total > MAX_BACKUPS )); then
        for ((j=MAX_BACKUPS; j<total; j++)); do
            echo "Deleted old backup: ${backups[$j]}"
            rm -f "${backups[$j]}"
        done
    fi
fi
