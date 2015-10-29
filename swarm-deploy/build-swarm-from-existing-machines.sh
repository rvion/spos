#!/bin/bash

set -e # fail when any subcommand fails
set -u # fail when an unknown variable is referenced
source log.sh # small utilities to log things

SPARK_MASTER_HOST='olivier-All-Series'
hosts='olivier-All-Series olivier-Bell olivier-Aspire-M7811'

# Note 1:
#   dig is a DNS lookup utility
#   $(dig +short $SPARK_MASTER_HOST) gets $SPARK_MASTER_HOST ip from the DNS

# Note 2:
#   Fun script to read about:
#   https://gist.github.com/oscarrenalias/becea3726edd67edb307

# Note 3:
#   One should also check swarm service discovery options
#   --consul-.., --etcd-.., etc.

SWARM_TOKEN=$(docker run --rm swarm create)

for host in $hosts
do
    if [ "$host" == "$SPARK_MASTER_HOST" ]; then
        docker-machine create \
            --driver generic \
            --generic-ip-address $(dig +short $host) \
            --generic-ssh-user $USER \
            --generic-ssh-key "/Users/$USER/.ssh/id_rsa" \
            --engine-label master=true \
            --engine-label worker=false \
            --swarm --swarm-discovery token://$SWARM_TOKEN \
            --swarm-master \
            $hosts
    else
        docker-machine create \
            --driver generic \
            --generic-ip-address $(dig +short $host) \
            --generic-ssh-user $USER \
            --generic-ssh-key "/Users/$USER/.ssh/id_rsa" \
            --engine-label worker=true \
            --engine-label master=false \
            --swarm --swarm-discovery token://$SWARM_TOKEN \
            $host
    fi
done