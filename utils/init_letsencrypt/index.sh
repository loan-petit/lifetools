#!/bin/sh

set -e

SOURCE_DIR=$( dirname "${BASH_SOURCE[0]}")

cd $SOURCE_DIR/../..

if ! [ -x "$(command -v docker-compose)" ]; then
  echo 'Error: docker-compose is not installed.' >&2
  exit 1
fi

domains=(lifetools.loanpetit.com www.lifetools.loanpetit.com)
rsa_key_size=4096
email="petit.loan1@gmail.com" # Adding a valid address is strongly recommended
staging=0 # Set to 1 if you're testing your setup to avoid hitting request limits

domains_path="/etc/letsencrypt/live/$domains"

echo "### Downloading recommended TLS parameters..."
docker run -v lifetools-certbot-conf:/etc/letsencrypt \
  -v "$(pwd)/utils/init_letsencrypt/install_tls_params.sh":/install_tls_params.sh \
  --rm alpine /bin/sh -c "/install_tls_params.sh && \
    mkdir -p \"/etc/letsencrypt/conf/live/$domains\" && \
    mkdir -p \"$domains_path\""
echo

echo "### Creating dummy certificate for $domains..."
docker-compose -f docker-compose.prod.yml run --rm --entrypoint " \
  openssl req -x509 -nodes -newkey rsa:1024 -days 1 \
    -keyout '$domains_path/privkey.pem' \
    -out '$domains_path/fullchain.pem' \
    -subj '/CN=localhost'" certbot
echo

echo "### Starting nginx..."
docker-compose -f docker-compose.prod.yml up --force-recreate -d nginx
echo

echo "### Deleting dummy certificate for $domains..."
docker-compose -f docker-compose.prod.yml run --rm --entrypoint " \
  rm -Rf /etc/letsencrypt/live/$domains && \
  rm -Rf /etc/letsencrypt/archive/$domains && \
  rm -Rf /etc/letsencrypt/renewal/$domains.conf" certbot
echo

# Join $domains to -d args
echo "### Requesting Let's Encrypt certificate for $domains..."
domain_args=""
for domain in "${domains[@]}"; do
  domain_args="$domain_args -d $domain"
done

# Select appropriate email arg
case "$email" in
  "") email_arg="--register-unsafely-without-email" ;;
  *) email_arg="--email $email" ;;
esac

# Enable staging mode if needed
if [ $staging != "0" ]; then staging_arg="--staging"; fi

docker-compose -f docker-compose.prod.yml run --rm --entrypoint " \
  certbot certonly --webroot -w /var/www/certbot \
    $staging_arg \
    $email_arg \
    $domain_args \
    --rsa-key-size $rsa_key_size \
    --agree-tos \
    --force-renewal" certbot
echo

echo "### Reloading nginx..."
docker-compose -f docker-compose.prod.yml exec -T nginx nginx -s reload
