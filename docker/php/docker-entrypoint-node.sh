#!/bin/sh
# Sngine PHP-FPM entrypoint wrapper.
# Installs the NodeJS socket server dependencies on first boot
set -e

NODE_DIR=/var/www/html/sockets/node

# Install if deps are missing
if [ -f "$NODE_DIR/package.json" ] && [ ! -d "$NODE_DIR/node_modules/socket.io" ]; then
  echo "[entrypoint] Installing NodeJS socket server dependencies..."
  (cd "$NODE_DIR" && npm install --omit=dev) || echo "[entrypoint] npm install failed (continuing)"
fi

exec docker-php-entrypoint "$@"
