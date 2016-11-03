#
# Cookbook Name:: test
# Recipe:: delivery
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

directory '/var/opt/delivery/license/' do
  recursive true
end

directory '/etc/delivery'
directory '/etc/chef'

delivery_databag = data_bag_item('automate', 'automate')

include_recipe 'chef-services::delivery_license'

file '/etc/delivery/delivery.pem' do
  content delivery_databag['user_pem']
end

file '/etc/chef/validation.pem' do
  content delivery_databag['validator_pem']
end

%w( delivery chefdk ).each do |svc|
  remote_file "#{svc} package" do
    path "#{node['chef_server']['install_dir']}/#{::File.basename(node[svc]['package_url'])}"
    source node[svc]['package_url']
    only_if { node[svc]['package_url'] }
  end

  chef_ingredient svc do
    config node[svc]['config'] if node[svc]['config']
    package_source "#{node['chef_server']['install_dir']}/#{::File.basename(node[svc]['package_url'])}" if node[svc]['package_url']
    accept_license node['chef-services']['accept_license']
    action :upgrade
  end

  ingredient_config svc do
    notifies :reconfigure, "chef_ingredient[#{svc}]", :immediately
  end
end

include_recipe 'chef-services::create_enterprise'
