#!/bin/bash

exec /app/omnisette-server --http-port "${PORT:-10000}" --https-port 8443 -l Info
