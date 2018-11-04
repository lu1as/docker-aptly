#!/bin/bash

aptly repo add "$REPO_NAME" /packages

mkdir -p /packages/imported
mv /packages/*.deb /packages/imported/
