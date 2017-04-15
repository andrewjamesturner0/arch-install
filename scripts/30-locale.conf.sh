#!/bin/bash
set -euo pipefail

_locale_conf='/etc/locale.conf'

if [[ ! -e "${_locale_conf}" ]]; then
    echo "LANG=en_GB.utf8" >> "${_locale_conf}"
    echo "LC_COLLATE=en_GB.utf8" >> "${_locale_conf}"
fi

localectl set-locale LANG=en_GB.UTF-8

locale-gen
