#!/bin/bash

set -e # fail when any subcommand fails
set -u # fail when an unknown variable is referenced
set -x

# This is just an example script that bootstrap 3 machines on virtualbox

SWARM_TOKEN=$(docker run --rm swarm create)

docker-machine create \
  --driver=virtualbox \
  --virtualbox-disk-size "12000" \
  --virtualbox-memory "1024" \
  --swarm --swarm-discovery token://$SWARM_TOKEN \
  --swarm-master \
  mm

for i in {1..2}; do
  docker-machine create \
    --driver=virtualbox \
    --virtualbox-disk-size "12000" \
    --virtualbox-memory "1024" \
    --swarm --swarm-discovery token://$SWARM_TOKEN \
    mw$i
done
