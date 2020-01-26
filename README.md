# LifeTools

## About LifeTools

LifeTools is a personal project created for better **management of daily habits
and daily goals**. It helps you building and sticking to habits that matter to you.

This idea came from a lack of applications matching my expectations in daily
routine management. LifeTools still is in a very early stage. Some crucial
features will be implemented over time.

Currently, this repository is open-sourced mostly to **showcase some of my
technical skills**.

LifeTools isn't currently available on the stores (Play Store and App Store) as
it still is rough, but it may be one day. Stay tuned.

## Application Preview

![Preview of LifeTools app](https://github.com/loan-petit/lifetools/blob/media/app_preview.png)

## Try the application in the browser

Please install Docker and docker-compose before running the following command.
([Get started with Docker](https://www.docker.com/get-started))

```bash
docker-compose up -d
```

This command may take some time as it build the whole app.
When it finishes, you can go to <http://localhost:80/>, create an account and use the web app.

## Application deployment

Thanks to GitHub Actions the deployment process is fully automatized.
It triggers when something is pushed onto master.

The application is deployed to an AWS EC2 instance using Docker images saved in
[petitloan/lifetools](https://hub.docker.com/r/petitloan/lifetools) Docker Hub public repository.

When the deployment is finised, the following containers should be running on the hosting server.

- **NGINX web server**: Based on petitloan/lifetools:nginx
- **Prisma2 GraphQL API**: Based on petitloan/lifetools:prisma
- **PostgreSQL database**: Based on postgres:12-alpine
- **Flutter application**: Based on petitloan/lifetools:flutter
- **Certbot for Let's Encrypt certificates administration**: Based on certbot/certbot

## Found this project useful?

Please consider giving it a star. :star:

You can also share it on social media.
