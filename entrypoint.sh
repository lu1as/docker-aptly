#!/bin/bash

GPG_BOOTSTRAP=${GPG_BOOTSTRAP:-true}
REPO_BOOTSTRAP=${REPO_BOOTSTRAP:-true}
REPO_AUTO_IMPORT=${REPO_AUTO_IMPORT:-true}

function gpg_bootstrap() {
    GPG_KEY_SIZE=${GPG_KEY_SIZE:-4096}

    if [ -z "$GPG_NAME" ] || [ -z "$GPG_EMAIL" ] || [ -z "$GPG_PASSPHRASE" ]; then
        echo "GPG_NAME, GPG_EMAIL and GPG_PASSPHRASE environment varibles are required"
        exit 1
    fi

    echo -e "\ncreate gpg key for package signing"
    cat >gpg_input <<EOF
Key-Type: 1
Key-Length: $GPG_KEY_SIZE
Subkey-Type: 1
Subkey-Length: $GPG_KEY_SIZE
Name-Real: $GPG_NAME
Name-Comment: aptly
Name-Email: $GPG_EMAIL
Expire-Date: 0
Passphrase: $GPG_PASSPHRASE
EOF

    gpg1 --batch --gen-key gpg_input
    rm gpg_input
    gpg1 --export --armor aptly > aptly_public_key.asc
}

function repo_bootstrap() {
    REPO_NAME=${REPO_NAME:-myrepo}
    REPO_DISTRIBUTION=${REPO_DISTRIBUTION:-debian}

    echo -e "\ncreate repository $REPO_NAME for distribution $REPO_DISTRIBUTION"
    aptly repo create "$REPO_NAME"
    /import.sh
    aptly -batch -passphrase="$GPG_PASSPHRASE" -distribution="$REPO_DISTRIBUTION" publish repo "$REPO_NAME"
}

if [ ! -f "/aptly/aptly_public_key.asc" ] && [[ "$GPG_BOOTSTRAP" == "true" ]]; then
    gpg_bootstrap
fi

if [ ! -d "/aptly/.aptly" ] && [[ "$REPO_BOOTSTRAP" == "true" ]]; then
    repo_bootstrap
fi

if [[ "$REPO_AUTO_IMPORT" == "true" ]]; then
    echo -e "\nstart cronjob for importing new packages"
    cron
fi

echo -e "\nserve on port 8080"
aptly serve -listen=:8080
