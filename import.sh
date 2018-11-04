#!/bin/bash

REPO_NAME=$1
aptly repo add "$REPO_NAME" /packages

if [ $? -eq 0 ]; then
    mkdir -p /packages/imported
    mv /packages/*.deb /packages/imported/
fi
