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

-c|--chef-server-fqdn               REQUIRED: The FQDN you want the Chef Server configured to use.\n
-a|--chef-automate-fqdn             The FQDN of the Chef Automate server.\n
-b|--build-node-fqdn                The FQDN of the build node.\n
-u|--user                           The ssh username we'll use to connect to other systems.\n
-p|--password                       The ssh password we'll use to connect to other systems.\n
-i|--install-dir                    The directory to use for the installer.
-cs-source|--chef-services-source   The source for the chef-services cookbook

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
    -i|--install-dir)
    INSTALL_DIR="$2"
    shift
    ;;
    -cs-source|--chef-services-source)
    CHEF_SERVICES_SOURCE="$2"
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

# ---------- Chef Server ----------
# ->install Chef
if [ -z "$INSTALL_DIR" ]; then
  INSTALL_DIR=/tmp
fi
if [ -z "$CHEF_SERVICES_SOURCE" ]; then
  CHEF_SERVICES_SOURCE="git: 'https://github.com/stephenlauck/chef-services.git'"
fi

mkdir -p $INSTALL_DIR/chef_installer/.chef/cache/
cd $INSTALL_DIR/chef_installer
if [ ! -d "/opt/chefdk" ]; then
  curl -LO https://omnitruck.chef.io/install.sh && sudo bash ./install.sh -P chefdk -d $INSTALL_DIR/chef_installer && rm install.sh
fi

# write out Berksfile of install cookbooks
cat << EOF > $INSTALL_DIR/chef_installer/Berksfile
source 'https://supermarket.chef.io'

cookbook 'chef-services', $CHEF_SERVICES_SOURCE
cookbook 'chef_stack', git: 'https://github.com/ncerny/chef_stack.git'
cookbook 'audit'
cookbook 'chef-client'
EOF

export PATH=/opt/chefdk/gitbin:$PATH

# download cookbooks for install
berks install
berks update
berks vendor cookbooks/

# write config and build chef-server
echo -e "{\"chef_server\": {\"fqdn\":\"$CHEF_SERVER_FQDN\",\"install_dir\":\"$INSTALL_DIR\"}}" > attributes.json
chef-client -z -j attributes.json --config-option file_cache_path=$INSTALL_DIR -r 'recipe[chef-services::chef-server]'

# upload cookbooks from chef-server to itself
berks upload --no-ssl-verify

# ---------- All others -----------
# -> automate,chef-builder1,chef-builder2,chef-builder3,supermarket,compliance.domain.com
# --> bootstrap with correct runlist

if [ ! -z $CHEF_AUTOMATE_FQDN ]; then
  knife bootstrap $CHEF_AUTOMATE_FQDN -N $CHEF_AUTOMATE_FQDN -x $CHEF_USER -P $CHEF_PW --sudo -r "role[patch],recipe[chef-services::delivery]" -j "{\"chef_server\":{\"fqdn\":\"$CHEF_SERVER_FQDN\"},\"chef_automate\":{\"fqdn\":\"$CHEF_AUTOMATE_FQDN\"}}" -E delivered -y --node-ssl-verify-mode none
fi

if [ ! -z $CHEF_BUILD_FQDN ]; then
  knife bootstrap $CHEF_BUILD_FQDN -N $CHEF_BUILD_FQDN -x $CHEF_USER -P $CHEF_PW --sudo -r "role[patch],recipe[chef-services::install_build_nodes]" -j "{\"chef_server\":{\"fqdn\":\"$CHEF_SERVER_FQDN\"},\"chef_automate\":{\"fqdn\":\"$CHEF_AUTOMATE_FQDN\"},\"tags\":\"delivery-build-node\"}" -E delivered -y --node-ssl-verify-mode none
fi

echo -e "{\"chef_server\": {\"fqdn\":\"$CHEF_SERVER_FQDN\",\"install_dir\":\"$INSTALL_DIR\"}, \"chef_environment\": \"delivered\"}" > attributes.json
chef-client -j attributes.json -r 'role[patch],recipe[chef-services::chef-server]'
