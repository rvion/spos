#!/bin/bash

set -e # fail when any subcommand fails
set -u # fail when an unknown variable is referenced

ifconfig $1 | awk '/inet / {print $2}' | awk '{gsub("addr:","");print}'