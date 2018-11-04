#!/bin/bash

REPO_NAME=$1
REPO_DISTRIBUTION=$2
GPG_PASSPHRASE=$3

aptly -remove-files repo add "$REPO_NAME" /incoming
aptly -batch -passphrase="$GPG_PASSPHRASE" publish update "$REPO_DISTRIBUTION"
