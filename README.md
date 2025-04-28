# 🛠️ DevOps - Task 2: Docker/Docker Compose

## 1. Project Setup

Create Docker containers for your project:

Create Docker containers for Backend, Frontend, Nginx, and PostgreSQL.

Environment variables are used to configure the connection between the components.

## 2. Create an `.env` file

In the root of your project, create a `.env` file with the following variables. Replace the placeholders with actual values.

### Database configuration

DB_HOST=
DB_NAME=
DB_USER=
DB_PASSWORD=
DB_PORT=

### Backend configuration

SECRET_KEY=e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b856
DEBUG=False
ALLOWED_HOSTS=0.0.0.0,localhost,127.0.0.1

### Frontend configuration

VITE_API_BASE_URL=http://localhost/
VITE_WEBSOCKET_BASE_URL=ws://localhost/

## 3. Build the Docker containers

Once the `.env` file is ready, you can build the containers by running:

```bash
docker-compose up --build
```

This command will:

- Build the Docker images for the backend, frontend, and Nginx services.
- Set up PostgreSQL and configure it with the environment variables in the `.env` file.

## 4. Run the containers

After the build process completes, the following services will be running:

- **PostgreSQL**: Database service for the backend.
- **Backend**: The backend Django application.
- **Frontend**: The frontend application.
- **Nginx**: Reverse proxy for handling HTTP requests and forwarding them to the backend and frontend.

To start the containers, use the following command:

```bash
docker-compose up
```

This will start the containers in the background and you will be able to access the following:

- **Frontend**: [http://localhost:8080](http://localhost:8080)
- **Backend**: The backend is available through Nginx at [http://localhost/api/](http://localhost/api/).

## 5. Accessing the backend container

If you need to enter the backend container to perform tasks (e.g., run Django management commands), you can do so by running:

```bash
docker exec -it <backend_container_id_or_name> /bin/bash
```

## 6. Stopping the containers

To stop the containers, run:

```bash
docker-compose down
```

This will stop and remove all containers, but the data in the PostgreSQL volume (`postgres_data`) will persist.

## 7. Clearing volumes (optional)

If you want to remove all the volumes, including PostgreSQL data, you can run:

```bash
docker-compose down -v
```

This will stop the containers and remove the volumes as well.

## Nginx Configuration

Nginx is configured as a reverse proxy:

- **Frontend**: Served on port 8080.
- **Backend**: Available through `/api/` on port 80.

If you need to make changes to the Nginx configuration, you can modify the `nginx/default.conf` file in the `nginx` directory.

## Troubleshooting

- **PostgreSQL container fails to start**: Ensure the environment variables for the database are correct in the `.env` file.
- **Backend not connecting to the database**: Check if the `DB_HOST` is set to `postgres` and the port is `5432` in the backend container environment.

```

```
