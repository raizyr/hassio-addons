#!/bin/bash
set -e

CERT_DIR=/data/letsencrypt
WORK_DIR=/data/workdir
CONFIG_PATH=/data/options.json


ACCEPT_TERMS=$(jq --raw-output '.letsencrypt.accept_terms' $CONFIG_PATH)
EMAIL=$(jq --raw-output ".email" $CONFIG_PATH)
DOMAINS=$(jq --raw-output ".domains[]" $CONFIG_PATH)
KEYFILE=$(jq --raw-output ".keyfile" $CONFIG_PATH)
CERTFILE=$(jq --raw-output ".certfile" $CONFIG_PATH)

if [ "$ACCEPT_TERMS" == "true" ]; then
    mkdir -p "$CERT_DIR"
    mkdir -p "$WORK_DIR"

    # Generate new certs
    if [ ! -d "$CERT_DIR/live" ]; then
        DOMAIN_ARR=()
        for line in $DOMAINS; do
            DOMAIN_ARR+=(-d "$line")
        done

        echo "$DOMAINS" > /data/domains.gen
        certbot certonly --non-interactive --dns-route53 --email "$EMAIL" --agree-tos --config-dir "$CERT_DIR" --work-dir "$WORK_DIR" "${DOMAIN_ARR[@]}"

    # Renew certs
    else
        certbot renew --non-interactive --config-dir "$CERT_DIR" --work-dir "$WORK_DIR"
    fi

    # copy certs to store
    cp "$CERT_DIR"/live/*/privkey.pem "/ssl/$KEYFILE"
    cp "$CERT_DIR"/live/*/fullchain.pem "/ssl/$CERTFILE"
fi