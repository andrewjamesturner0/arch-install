#!/usr/bin/env bash
# exit on errors
set -euo pipefail

# install puppet and modules
pacman -Syu --noconfirm puppet
gem install ruby-shadow
puppet module install puppetlabs-stdlib
mkdir -p /etc/puppetlabs/code/modules
cp -r ../puppet/archlinux /etc/puppetlabs/code/modules

# apply
puppet apply ../environments/site.pp
