#!/bin/sh

set -e

config_path="/etc/letsencrypt"

if [ ! -e "$config_path/options-ssl-nginx.conf" ] || [ ! -e "$config_path/ssl-dhparams.pem" ]; then
  mkdir -p "$config_path"
  apk update && apk upgrade && apk add --no-cache curl
  curl -s https://raw.githubusercontent.com/certbot/certbot/master/certbot-nginx/certbot_nginx/_internal/tls_configs/options-ssl-nginx.conf > "$config_path/options-ssl-nginx.conf"
  curl -s https://raw.githubusercontent.com/certbot/certbot/master/certbot/certbot/ssl-dhparams.pem > "$config_path/ssl-dhparams.pem"
fi
