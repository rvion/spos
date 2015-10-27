#!/bin/sh
ifconfig $1 | awk '/inet / {print $2}' | awk '{gsub("addr:","");print}'