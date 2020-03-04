FROM nginx:alpine

ARG APP_ENV

COPY nginx.$APP_ENV.conf /etc/nginx/nginx.conf

RUN mkdir -p /data/nginx/cache 