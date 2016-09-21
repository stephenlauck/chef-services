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

#curl -LO https://omnitruck.chef.io/install.sh && sudo bash ./install.sh -P chefdk && rm install.sh

echo 'cookbook_path \"/tmp/workspace/cookbooks\"' > /tmp/solo.rb
sudo chef-solo -c /tmp/solo.rb -o 'recipe[chef_server::default]'

mkdir /tmp/chef_installer
yum install git -y
cat > /tmp/chef_installer/Berksfile <<EOF
source 'https://supermarket.chef.io'

cookbook 'chef-server-ctl', git: 'https://github.com/stephenlauck/chef-server-ctl.git'
cookbook 'chef-services', git: 'https://github.com/stephenlauck/chef-services.git', branch: 'installer'
cookbook 'chef-ingredient', git: 'https://github.com/chef-cookbooks/chef-ingredient.git'

EOF

cd /tmp/chef_installer/
berks install
berks vendor cookbooks/

# ->scp/upload cookbook tarball
# ->chef-client -z with Chef server cookbook (from tarball ^^)
chef-client -z -r "test::chef-server"

# ->upload cookbooks to itself
# ->generate keys, create data_bags
# ->bootstrap Chef to Chef
# ---------- All others -----------
# -> automate,chef-builder1,chef-builder2,chef-builder3,supermarket,compliance.domain.com
# --> bootstrap with correct runlist
