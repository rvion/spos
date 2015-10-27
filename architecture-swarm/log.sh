#!/usr/bin/env bash

colored() {
    printf "\33[38;5;$1m%s\33[0m\n" "$2"
}

info() {
    colored 50 "$1"
}

warning() {
    colored 202 "$1"
}

error() {
    colored 9 "$1"
}

step() {
    printf "\n"
    colored 190 "$1"
}
