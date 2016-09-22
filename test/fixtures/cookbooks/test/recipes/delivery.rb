#
# Cookbook Name:: test
# Recipe:: delivery
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

directory '/var/opt/delivery/license/' do
  recursive true
end

file '/var/opt/delivery/license/delivery.license' do
  content ::File.read("/tmp/chef_automate.license")
  owner 'root'
  group 'root'
  mode 00644
end

directory '/etc/delivery'
delivery_databag = data_bag_item('automate', 'automate')

file '/etc/delivery/delivery.pem' do
  content delivery_databag['user_pem']
end

file '/etc/chef/validation.pem' do
  content delivery_databag['validator_pem']
end

chef_ingredient 'delivery' do
  config <<-EOS
delivery_fqdn "#{node['ec2']['public_hostname']}"
delivery['chef_username']    = "delivery"
delivery['chef_private_key'] = "/etc/delivery/delivery.pem"
delivery['chef_server']      = "https://#{node['chef_automate']['chef_server']}/organizations/delivery"
delivery['default_search']   = "tags:delivery-build-node"
insights['enable']           = true
  EOS
  action :install
end

ingredient_config 'delivery' do
  notifies :reconfigure, 'chef_ingredient[delivery]', :immediately
end

include_recipe 'chef_automate::_create_enterprise'
include_recipe 'chef_automate::_install_build_nodes'
