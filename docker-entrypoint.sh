#!/bin/bash
echo "DEBUG: Entrypoint running as user $(id -u), attempting to bind to port ${PORT:-10000}"

exec /opt/omnisette-server/omnisette-server --http-port "${PORT:-10000}" --https-port 8443 -l Info
