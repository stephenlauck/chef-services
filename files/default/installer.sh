#!/bin/bash

#
# Please provide an IP/FQDN for your chef server: domain.com

# Do you want to connect by ssh key or user/pass?
# Please provide a ssh username:
# Please provide a ssh password:
# --or--
# Please provide a ssh key:
#
# ---------- Chef Server ----------
# ->install Chef
mkdir -p /tmp/chef_installer
cd /tmp/chef_installer
curl -o /tmp/chef_installer/installer.rb https://raw.githubusercontent.com/stephenlauck/chef-services/installer/files/default/installer.rb
if [ ! -d "/opt/chefdk" ]; then
  curl -LO https://omnitruck.chef.io/install.sh && sudo bash ./install.sh -P chefdk && rm install.sh
fi
chef-apply /tmp/chef_installer/installer.rb
chef-client -z -j attributes.json -r "recipe[test::chef-server],recipe[test::save_secrets]"

# ->upload cookbooks to itself
# ->generate keys, create data_bags
# ->bootstrap Chef to Chef
# ---------- All others -----------
# -> automate,chef-builder1,chef-builder2,chef-builder3,supermarket,compliance.domain.com
# --> bootstrap with correct runlist
