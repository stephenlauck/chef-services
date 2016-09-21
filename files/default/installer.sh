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

curl -L https://www.chef.io/chef/install.sh -P chefdk | sudo bash
echo 'cookbook_path \"/tmp/workspace/cookbooks\"' > /tmp/solo.rb
sudo chef-solo -c /tmp/solo.rb -o 'recipe[chef_server::default]'

cat > /tmp/workspace/Berksfile <<EOF
source 'https://supermarket.chef.io'

cookbook 'chef-server-ctl', git: 'https://github.com/stephenlauck/chef-server-ctl.git'
cookbook 'chef_server', path: 'cookbooks/chef_server'
cookbook 'chef_automate', path: 'cookbooks/chef_automate'
EOF

cd /tmp/workspace/
berks install
berks vendor cookbooks/





# ->scp/upload cookbook tarball
# ->chef-client -z with Chef server cookbook (from tarball ^^)
# ->upload cookbooks to itself
# ->generate keys, create data_bags
# ->bootstrap Chef to Chef
# ---------- All others -----------
# -> automate,chef-builder1,chef-builder2,chef-builder3,supermarket,compliance.domain.com
# --> bootstrap with correct runlist
