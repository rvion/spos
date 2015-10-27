#!/bin/bash

set -e # fail when any subcommand fails
set -u # fail when an unknown variable is referenced
source log.sh # small utilities to log things
# $0 is the name of the command
# $1 first parameter
# $2 second parameter
# $3 third parameter etc. etc
# $# total number of parameters
# $@ all the parameters will be listed

terminal="gnome-terminal"
open="gnome-open"
master='olivier-All-Series'
workers='olivier-Bell olivier-Aspire-M7811'
hosts= "$master $workers"
# hosts=$(docker-machine ls -q')

# 1: Starting Docker engine on all hosts ---------------------------------
startDockerDaemon="docker daemon -H tcp://0.0.0.0:2375"
for host in $hosts
do 
	step "starting docker engine on $host ..."
	if eval 'docker -H tcp://$host:2375 info'
	then
		info "doker daemon already running and listening on tcp://$host:2375"
	else
		if $host==$(hostname)
		then
			info "starting docker daemon on localhost ($host)"
			sudo $startDockerDaemon &
		else
			info "starting docker daemon on $host over ssh"
			ssh $USER@$host "sudo $startDockerDaemon" &
		fi
	fi
done 

# 2: Creating a swarm -----------------------------------------------------
step "creating a swarm"
SWARM_ID=$(docker run --rm swarm create)
echo new swarm created : $SWARM_ID 
dk="docker -H tcp://0.0.0.0:2375"

for host in $hosts
do 
	info "cleaning $host"
	ssh $USER@$host '$dk rm -f $($dk ps -q -a)'
	ssh $USER@$host '$dk run -d swarm join --addr=\$(hostname -I | awk '{print \$1}'):2375 token://$SWARM_ID'
done 

step "Create swarm master (~10s)"
$dk run -d -p 9999:2375 swarm manage token://$SWARM_ID
sleep 10

alias dswarm='docker -H tcp://0.0.0.0:9999'

# not sure about this one:
#   for cont in $(dswarm ps -q)
#   do
#     dswarm rm -f $cont
#   done

# 3: Starting master ---------------------------------------------------------
# step "launching master"
# dswarm run\
#  --net=host -d \
#  --name sparkmaster\
#  randompulse/newspark:latest\
#  bash -c "./bin/spark-class org.apache.spark.deploy.master.Master"
# # bash -c "SPARK_MASTER_IP=\$(hostname -I | awk '{print \$1}') ./bin/spark-class org.apache.spark.deploy.master.Master"
# sleep 5

# MASTER_IP=""
# MASTER_IP=$(dswarm inspect --format '{{ .Node.IP }}' sparkmaster)
# if [[ -z $MASTER_IP ]]
# then
# 	echo failed to create master
# 	return
# else
# 	echo '############################################################'
# 	echo '#'
# 	echo look for master UI at $MASTER_IP:8082
# fi

# step 'launching workers'
# for x in 1 2 3
# do
# 	info "launching worker $x"
# 	dswarm run\
# 	 -d\
# 	 --name sparkworker$x\
# 	 --net=host \
# 	 randompulse/newspark:latest \
# 	 bash -c "./bin/spark-class org.apache.spark.deploy.worker.Worker spark://$MASTER_IP:7077"
# 	 #"SPARK_LOCAL_IP=\$(hostname -I | awk '{print \$1}')"
# done

# step 'launching spark shell'
# dswarm run\
#  --rm -it\
#  --net=host\
#  --name sparkshell\
#  randompulse/newspark:latest \
#  bash -c "./bin/spark-shell --master spark://$MASTER_IP:7077"
# # bash -c "SPARK_LOCAL_IP=\$(hostname -I | awk '{print \$1}') ./bin/spark-shell --master spark://$MASTER_IP:7077"


# #look for master webui on port 8082
# $open http://$(dswarm inspect --format '{{ .Node.IP }}' sparkmaster):8082
