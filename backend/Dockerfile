FROM python:3.12-alpine AS build

WORKDIR /app

# Update and install security patches for Alpine OS
RUN apk update && apk upgrade && \
    apk add --no-cache gcc libc-dev libpq-dev

# Install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the app
COPY . .

# Run the app
CMD ["./start.sh"]
