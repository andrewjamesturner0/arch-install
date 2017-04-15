#!/bin/bash

install_scripts=( \
    30-hostname.sh \
    30-locale.conf.sh \
    30-localtime.sh)

source looper.sh
main

echo ':: Basic install done.'
