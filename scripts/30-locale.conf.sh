#!/usr/bin/env bash
set -euo pipefail

_locale_conf='/etc/locale.conf'

if [[ ! -e "${_locale_conf}" ]]; then
    echo "LANG=${INSTALL_LOCALE}" >> "${_locale_conf}"
    echo "LC_COLLATE=${INSTALL_LOCALE}" >> "${_locale_conf}"
fi

localectl set-locale "LANG=${INSTALL_LOCALE}"

locale-gen
