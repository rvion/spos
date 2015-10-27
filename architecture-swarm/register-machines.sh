#!/bin/bash

set -e # fail when any subcommand fails
set -u # fail when an unknown variable is referenced
source log.sh # small utilities to log things

master='olivier-All-Series'
workers='olivier-Bell olivier-Aspire-M7811'

docker-machine create \
    --driver generic \ 
    --generic-ip-address $(dig +short $master) \
    --generic-ssh-user $USER \
    --generic-ssh-key "/Users/$USER/.ssh/id_rsa" \
    --engine-label master=true
    --swarm \
    --swarm-master \
    --swarm-discovery token://$SWARM_TOKEN \
    mm

i=1
for host in $workers
do 
	docker-machine create \
	    --driver generic \ 
	    --generic-ip-address $(dig +short $host) \
	    --generic-ssh-user $USER \
	    --generic-ssh-key "/Users/$USER/.ssh/id_rsa" \
	    --engine-label worker=true
	    m$i
	i=$(($i + 1))
done