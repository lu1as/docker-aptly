FROM debian:buster-slim

LABEL maintainer="lukas.steiner@steinheilig.de"
LABEL repository="github.com/lu1as/docker-aptly"

RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y cron sudo gnupg1 aptly \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && useradd -m -d /aptly -s /bin/bash aptly \
    && echo "aptly ALL=NOPASSWD: ALL" >> /etc/sudoers

COPY entrypoint.sh /entrypoint.sh
COPY add_incoming.sh /add_incoming.sh

USER aptly
WORKDIR /aptly
VOLUME /aptly
VOLUME /incoming

CMD [ "/entrypoint.sh" ]
