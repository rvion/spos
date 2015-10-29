#!/bin/bash

set -e # fail when any subcommand fails
set -u # fail when an unknown variable is referenced

docker run -it --net=host --rm rvion/spark
