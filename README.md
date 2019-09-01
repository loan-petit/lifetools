# LifeTools

## About LifeTools

LifeTools is a personal project created for better **management of daily habits
and daily goals**. It helps you building and sticking to habits that matter to you.

This idea came from a lack of any applications matching my expectations in daily
routine management. LifeTools is still is in a very early stage. Some crucial
features will be implemented over time.

Currently, this repository is open-sourced mostly to showcase some of my
technical skills.

LifeTools isn't currently available on the stores (Play Store and App Store) as
it still is rough, but it may be one day. Stay tuned. 

## Application Preview

![Preview of LifeTools app](https://github.com/loan-petit/lifetools/blob/media/app_preview.png)

## Build the project

Please install Docker and docker-compose before running the following commands.
([Get started with Docker](https://www.docker.com/get-started))

* For development:

    ```bash
    docker-compose up -d
    ```

* For production:

    ```bash
    docker-compose -f docker-compose.prod.yml up -d
    ```

These commands will create and start the following containers:
- **NGINX web server**: lifetools_nginx
- **Prisma2 GraphQL API**: lifetools_prisma
- **Flutter application**: lifetools_flutter
- **PostgreSQL database**: lifetools_postgres
- **Certbot for Let's Encrypt certificates administration**: lifetools_certbot *(production only)*