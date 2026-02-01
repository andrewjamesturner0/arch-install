#!/usr/bin/env bash
# exit on errors
set -euo pipefail

# install puppet and modules
pacman -S --noconfirm puppet
gem install ruby-shadow
puppet module install puppetlabs-stdlib
mkdir -p /etc/puppetlabs/code/modules
cp -r "${_repo_dir}/puppet/archlinux" /etc/puppetlabs/code/modules

# apply
puppet apply "${_repo_dir}/environments/site.pp"
