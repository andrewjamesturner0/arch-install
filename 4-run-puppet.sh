#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/looper.sh"

install_scripts=(40-prepare-puppet.sh)

main

echo ':: Puppet install done.'
