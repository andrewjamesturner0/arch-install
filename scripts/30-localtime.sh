#!/bin/bash
set -euo pipefail

timedatectl set-timezone Europe/London

hwclock --systohc --utc
