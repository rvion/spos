#!/bin/bash

set -e # fail when any subcommand fails
set -u # fail when an unknown variable is referenced
set -x # fail when an unknown variable is referenced
source log.sh # small utilities to log things

# For RV
hosts=$(docker-machine ls -q)
master="m1"
sshCmd="docker-machine ssh"

dk="docker -H tcp://0.0.0.0:2375"
killAllContainers="$dk rm -f \$($dk ps -q -a)"
for host in $hosts
do 
	info "kill all containers on $host"
	if eval 'docker -H tcp://$(docker-machine ip $host):2375 info'
	then
		if $host==$(hostname)
		then
			eval $killAllContainers
		else
			eval "$sshCmd $host \"$killAllContainers\""
		fi
	else
		info "doker daemon not running on tcp://$host:2375"
	fi
done 
