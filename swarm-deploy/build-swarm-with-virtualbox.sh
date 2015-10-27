#!/bin/bash

set -e # fail when any subcommand fails
set -u # fail when an unknown variable is referenced

dm create --driver=virtualbox --virtualbox-disk-size "12000" -virtualbox-memory "1024" mm
for i in {1..4}
	dm create --driver=virtualbox --virtualbox-disk-size "12000" -virtualbox-memory "1024" mw$i
