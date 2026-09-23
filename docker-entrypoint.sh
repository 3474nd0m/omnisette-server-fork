#!/bin/bash

exec /opt/omnisette-server/omnisette-server --http-port "${PORT:-10000}" --https-port 8443 -l Info
