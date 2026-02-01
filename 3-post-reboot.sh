#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/looper.sh"

install_scripts=(
    30-hostname.sh
    30-locale.conf.sh
    30-localtime.sh
)

main

echo ':: Basic install done.'
