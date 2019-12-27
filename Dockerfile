FROM debian:stable

ARG APTLY_VERSION=1.4.0

LABEL maintainer="lukas.steiner@steinheilig.de"
LABEL repository="github.com/lu1as/docker-aptly"
LABEL version=${APTLY_VERSION}

RUN apt-get update \
    && apt-get install -y gnupg1 gpgv1 cron sudo \
    && echo "deb http://repo.aptly.info/ squeeze main" > /etc/apt/sources.list.d/aptly.list \
    && apt-key adv --fetch-keys https://www.aptly.info/pubkey.txt \
    && apt-get update \
    && apt-get install -y aptly=${APTLY_VERSION} \
    && apt-get clean \
    && useradd -m -d /aptly -s /bin/bash aptly \
    && echo "aptly ALL=NOPASSWD: ALL" >> /etc/sudoers

COPY entrypoint.sh /entrypoint.sh
COPY add_incoming.sh /add_incoming.sh

USER aptly
WORKDIR /aptly
VOLUME /aptly
VOLUME /incoming

CMD [ "/entrypoint.sh" ]
