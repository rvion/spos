#!/bin/bash

set -e # fail when any subcommand fails
set -u # fail when an unknown variable is referenced

docker push rvion/spark:0.1
