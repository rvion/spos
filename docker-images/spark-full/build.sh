#!/bin/bash

set -e # fail when any subcommand fails
set -u # fail when an unknown variable is referenced

docker build -t rvion/spark:0.1 .
