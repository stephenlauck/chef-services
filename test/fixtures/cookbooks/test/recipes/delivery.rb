#
# Cookbook Name:: test
# Recipe:: delivery
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

directory '/var/opt/delivery/license/' do
  recursive true
end

directory '/etc/delivery'
delivery_databag = data_bag_item('automate', 'automate')


file '/var/opt/delivery/license/delivery.license' do
  content delivery_databag['license_file']
  owner 'root'
  group 'root'
  mode 00644
end

file '/etc/delivery/delivery.pem' do
  content delivery_databag['user_pem']
end

file '/etc/chef/validation.pem' do
  content delivery_databag['validator_pem']
end

chef_ingredient 'delivery' do
  config <<-EOS
delivery_fqdn "#{node['chef_automate']['fqdn']}"
delivery['chef_username']    = "delivery"
delivery['chef_private_key'] = "/etc/delivery/delivery.pem"
delivery['chef_server']      = "https://#{node['chef_server']['fqdn']}/organizations/delivery"
delivery['default_search']   = "tags:delivery-build-node"
insights['enable']           = true
  EOS
  action :install
end

ingredient_config 'delivery' do
  notifies :reconfigure, 'chef_ingredient[delivery]', :immediately
end

include_recipe 'test::create_enterprise'
include_recipe 'test::install_build_nodes'
