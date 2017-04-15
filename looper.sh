#!/bin/bash
#
#   This program is free software; you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#   the Free Software Foundation; either version 3 of the License, or
#   (at your option) any later version.
#
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU General Public License for more details.
#
#   You should have received a copy of the GNU General Public License
#   along with this program.  If not, see <http://www.gnu.org/licenses/>.
#



## === messages ===
msg0() {
    local _bold="\e[1;1m"
    local _off="\e[1;0m"
    local mesg=$1; shift
    printf "${_bold}${mesg}${_off}\n" "$@" >&1
}

msg1() {
    local mesg=$1; shift
    printf " >>> ${mesg}\n" "$@" >&1
}


## === main ===
main() {
if [[ ! -d log ]]; then mkdir "log"; fi
cd scripts
for i in ${install_scripts[@]}; do
    msg0 "Running: ${i}"
    if ./${i} > ../log/${i%%.*}.log 2>&1; then
        msg1 "Success"
    else
        msg1 "Error: See log/${i%%.*}.log"
        exit 1
    fi
done
}
