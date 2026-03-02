#!/bin/zsh
set -e

# Create entrypoint if needed
if [ ! -e "/usr/local/share/with-docker-entrypoint.sh" ]; then
    echo "Setting up entrypoint..."
    cp -f entrypoint.sh /usr/local/share/with-docker-entrypoint.sh
    chmod +x /usr/local/share/with-docker-entrypoint.sh
fi
