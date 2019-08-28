# LifeTools

## Start the project

* For development:

    ```bash
    docker-compose up -d
    ```

* For production:

    ```bash
    docker-compose -f docker-compose.prod.yml up -d
    ```

This command will create and start the following containers:
- **NGINX web server**: "lifetools_nginx"
- **Prisma API**: "lifetools_prisma"
- **Flutter application**: "lifetools_flutter"
- **PostgreSQL database**: "lifetools_postgres"
- **Certbot**: "lifetools_certbot" *(production only)*

### NGINX Web Server

This server is used as a reverse proxy and as a load balancer.
It provides access to the Flutter app and the Prisma API to the host.

The used ports are: 
 - 80 for the Flutter application with HTTP protocol. *(redirected to 443 in production)*
 - 443 for the Flutter application with HTTPS protocol. *(production only)*
 - 8081 for the Prisma API.

### Prisma API

The application's backend. It lets us interact with the database through GraphQL endpoint. 

The API port isn't accessible from the host. Instead, use the port 8081 proxied by NGINX.

The whole API documentation is provided at the '/' route in development mode.

### Flutter Application

This is a hybrid application.

The application port isn't accessible from the host. 

To access the application, use the port 80 in development and 443 in production.
Those are proxied by NGINX.

### PostgreSQL database

The application database is accessible on port 5432. This database is associated with a Docker volume.
The volume is bind to ./data/postgres/ on host.

### Certbot (production only)

This bot can only be used in a production environment with a public IP.
We use it to generate an SSL certificate and to update it regularly.
This certificate is used by NGINX in order to provide HTTPS support.
