#!/bin/bash

#
# Please provide an IP/FQDN for your chef server: domain.com

read -e -p "We are about to install Chef server on this system, proceed? (y/n) [n] " -i "y" name
name=${name:-n}

read -e -p "Please provide an IP/FQDN for your chef server: " -i "chef.services.com" chef_server_fqdn
read -e -p "Do you want to bootstrap your Delivery server with knife? (y/n) [n]" -i "y" bootstrap_more
bootstrap_more=${bootstrap_more:-n}

if [ "$bootstrap_more" == "y" ]; then
  read -e -p "Please provide an IP/FQDN for your Automate server: " -i "automate.services.com" chef_automate_fqdn
  read -e -p "What's the SSH username for your Automate server: " -i "vagrant" chef_automate_user
  read -e -p "What's the SSH password for your Automate server: " -i "vagrant" chef_automate_pw
  read -e -p "Please provide an IP/FQDN for your Build node: " -i "build.services.com" chef_build_fqdn
  read -e -p "What's the SSH username for your Build node: " -i "vagrant" chef_build_user
  read -e -p "What's the SSH password for your Build node: " -i "vagrant" chef_build_pw
fi

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
curl -o /tmp/chef_installer/installer.rb https://raw.githubusercontent.com/stephenlauck/chef-services/ad/fixes/files/default/installer.rb
if [ ! -d "/opt/chefdk" ]; then
  curl -LO https://omnitruck.chef.io/install.sh && sudo bash ./install.sh -P chefdk && rm install.sh
fi
chef-apply /tmp/chef_installer/installer.rb
echo -e "{\"chef_server\": {\"fqdn\":\"$chef_server_fqdn\"}}" > /tmp/chef_installer/attributes.json
chef-client -z -j attributes.json -r 'recipe[test::hostsfile],recipe[test::chef-server],recipe[test::delivery_license],recipe[test::save_secrets]'

# ->upload cookbooks to itself
# ->generate keys, create data_bags
# ->bootstrap Chef to Chef
# ---------- All others -----------
# -> automate,chef-builder1,chef-builder2,chef-builder3,supermarket,compliance.domain.com
# --> bootstrap with correct runlist

if [ "$bootstrap_more" == "y" ]; then
  knife bootstrap $chef_build_fqdn -N $chef_build_fqdn -x $chef_build_user -P $chef_build_pw --sudo -r "recipe[hostsfile]" -y
  knife bootstrap $chef_automate_fqdn -N $chef_automate_fqdn -x $chef_automate_user -P $chef_automate_pw --sudo -r "recipe[hostsfile],recipe[chef_automate]" -j "{\"chef_automate\":{\"fqdn\":\"$chef_automate_fqdn\",\"build_nodes\":[{\"fqdn\":\"$chef_build_fqdn\",\"username\":\"$chef_build_user\",\"password:\":\"$chef_build_pw\"}]}}" -y
fi

chef-client -j attributes.json -r 'recipe[test::chef-server]'
