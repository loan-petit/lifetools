FROM node:latest

RUN mkdir /prisma/

WORKDIR /prisma/

RUN npm install -g prisma2 --unsafe-perm

COPY ./schema.prisma .

RUN mkdir migrations

ENTRYPOINT []
