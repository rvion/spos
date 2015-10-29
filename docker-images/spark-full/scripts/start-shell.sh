#!/bin/bash

set -e # fail when any subcommand fails
set -u # fail when an unknown variable is referenced

SPARK_LOCAL_IP=$(/spark/getIpOnInterface.sh eth1) ./bin/spark-shell --master $MASTER_PATH
