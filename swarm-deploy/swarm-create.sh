#!/bin/bash

set -e # fail when any subcommand fails
set -u # fail when an unknown variable is referenced
source log.sh # small utilities to log things

# For OS
# master="olivier-All-Series"
# hosts="olivier-All-Series olivier-Bell olivier-Aspire-M7811"
# sshCmd="ssh $USER@"

# For RV
hosts=($(docker-machine ls -q))

step "Initializing new swarm cluster.."
SWARM_ID=$(docker run --rm swarm create)
info "new swarm created : $SWARM_ID"
info "done"

startDockerDaemon="docker daemon -H tcp://0.0.0.0:2375"
dk="docker -H tcp://0.0.0.0:2375"
getIP="hostname -I | awk '{print \$1}'"
alias dswarm='docker -H tcp://0.0.0.0:9999'

for host in $hosts
do 
	step "starting docker engine on $host ..."
	if eval 'docker -H tcp://$host:2375 info'
	then
		info "doker daemon already running and listening on tcp://$host:2375"
		$sshCmd '$dk rm -f $($dk ps -q -a)'
		$sshCmd '$dk run -d swarm join --addr=\$($sshCmd):2375 token://$SWARM_ID'
	else
		if $host==$(hostname)
		then
			info "starting docker daemon on localhost ($host)"
			eval "sudo $startDockerDaemon &"
			step "starting swarm master"
			$dk run -d -p 9999:2375 swarm manage token://$SWARM_ID
			sleep 10
		else
			info "starting docker daemon on $host over ssh"
			ssh $USER@$host "sudo $startDockerDaemon" &
			$sshCmd '$dk run -d swarm join --addr=\$($sshCmd):2375 token://$SWARM_ID'
		fi
	fi
done 
