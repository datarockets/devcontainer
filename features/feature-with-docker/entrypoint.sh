#!/bin/zsh
set -e

if [ -S /var/run/docker.sock ]; then
    DOCKER_GID=$(stat -c '%g' /var/run/docker.sock)
    CURRENT_GID=$(getent group docker | cut -d: -f3)

    if [ "$DOCKER_GID" != "$CURRENT_GID" ]; then
        sudo groupmod -g "$DOCKER_GID" docker
        exec sudo setpriv --init-groups --reuid=$(id -u) --regid=$(id -g) -- "$@"
    fi
fi

exec "$@"
