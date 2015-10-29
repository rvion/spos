#!/bin/bash

set -e # fail when any subcommand fails
set -u # fail when an unknown variable is referenced

# This is just an example script that bootstrap 5 machines on virtualbox

SWARM_TOKEN=$(docker run --rm swarm create)

dm create \
  --driver=virtualbox \
  --virtualbox-disk-size "12000" \
  --virtualbox-memory "1024" \
  --swarm --swarm-discovery token://$SWARM_TOKEN \
  --swarm-master \
  mm

for i in {1..4}; do
  dm create \
    --driver=virtualbox \
    --virtualbox-disk-size "12000" \
    --virtualbox-memory "1024" \
    --swarm --swarm-discovery token://$SWARM_TOKEN \
    mw$i
done
