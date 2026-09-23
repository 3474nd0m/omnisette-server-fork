#!/bin/bash

echo "DEBUG: uid=$(id -u) cwd=$(pwd) port=${PORT:-10000}"

exec /opt/omnisette-server/omnisette-server --http-port "${PORT:-10000}" --https-port 8443 -l Info
