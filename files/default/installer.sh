#!/bin/bash

#
# Please provide an IP/FQDN for your chef server: domain.com
#
# Hab package?
#

usage="
This is an installer for Chef. It will install Chef Server, Chef Automate, and a build node for Automate.\n
It will install the Chef server on the system you run this script from.\n

You must specify the following options:\n

-c|--chef-server-fqdn         REQUIRED: The FQDN you want the Chef Server configured to use.\n
-a|--chef-automate-fqdn       The FQDN of the Chef Automate server.\n
-b|--build-node-fqdn          The FQDN of the build node.\n
-u|--user                     The ssh username we'll use to connect to other systems.\n
-p|--password                 The ssh password we'll use to connect to other systems.\n

If only -c is specified the local system will be configured with a Chef Server install. \n
"

if [ $# -eq 0 ]; then
  echo -e $usage
  exit 1
fi

while [[ $# -gt 0 ]]
do
key="$1"
case $key in
    -c|--chef-server-fqdn)
    CHEF_SERVER_FQDN="$2"
    shift # past argument
    ;;
    -a|--chef-automate-fqdn)
    CHEF_AUTOMATE_FQDN="$2"
    shift # past argument
    ;;
    -b|--build-node-fqdn)
    CHEF_BUILD_FQDN="$2"
    shift # past argument
    ;;
    -u|--user)
    CHEF_USER="$2"
    shift
    ;;
    -p|--password)
    CHEF_PW="$2"
    shift
    ;;
    -h|--help)
    echo -e $usage
    exit 0
    ;;
    *)
    echo "Unknown option $1"
    echo -e $usage
    exit 1
    ;;
esac
shift # past argument or value
done

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
echo -e "{\"chef_server\": {\"fqdn\":\"$CHEF_SERVER_FQDN\"}}" > /tmp/chef_installer/attributes.json
chef-client -z -j attributes.json -r 'recipe[test::chef-server],recipe[test::delivery_license],recipe[test::save_secrets]'

# ->upload cookbooks to itself
# ->generate keys, create data_bags
# ->bootstrap Chef to Chef
# ---------- All others -----------
# -> automate,chef-builder1,chef-builder2,chef-builder3,supermarket,compliance.domain.com
# --> bootstrap with correct runlist

if [ ! -z $CHEF_AUTOMATE_FQDN ]; then
  knife bootstrap $CHEF_AUTOMATE_FQDN -N $CHEF_AUTOMATE_FQDN -x $CHEF_USER -P $CHEF_PW --sudo -r "recipe[test::delivery]" -j "{\"chef_server\":{\"fqdn\":\"$CHEF_SERVER_FQDN\"},\"chef_automate\":{\"fqdn\":\"$CHEF_AUTOMATE_FQDN\",\"build_nodes\":[{\"fqdn\":\"$CHEF_BUILD_FQDN\",\"username\":\"$CHEF_USER\",\"password\":\"$CHEF_PW\"}]}}" -y --node-ssl-verify-mode none
fi

chef-client -j attributes.json -r 'recipe[test::chef-server]'
