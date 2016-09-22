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
if [ ! -d "/opt/chefdk" ]; then
  curl -LO https://omnitruck.chef.io/install.sh && sudo bash ./install.sh -P chefdk && rm install.sh
fi
rm -rf /tmp/chef_installer/cookbooks
#rm -rf ~/.chef/local_mode_cache/cache/cookbooks
chef-apply /tmp/chef_installer/installer.rb
cd /tmp/chef_installer/
chef-client -z -j attributes.json -r "recipe[test::chef-server],recipe[test::save_secrets]"

# ->upload cookbooks to itself
# ->generate keys, create data_bags
# ->bootstrap Chef to Chef
# ---------- All others -----------
# -> automate,chef-builder1,chef-builder2,chef-builder3,supermarket,compliance.domain.com
# --> bootstrap with correct runlist
