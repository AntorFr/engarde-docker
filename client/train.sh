#!/bin/sh
# Starts engarde-client on the laptop, building it first if needed (in Docker,
# nothing installed on the host). Then switch WireGuard to the "Train" profile.
# Status page: http://127.0.0.1:9001
set -e
cd "$(dirname "$0")"
if [ ! -x .bin/engarde-client ]; then
  docker build --target client-darwin --output .bin ..
fi
exec .bin/engarde-client engarde.yml
