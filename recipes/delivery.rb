#
# Cookbook Name:: test
# Recipe:: delivery
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

delivery_databag = data_bag_item('automate', 'automate')

chef_automate 'automate.services.com' do
  chef_user 'delivery'
  chef_user_pem delivery_databag['user_pem']
  validation_pem delivery_databag['validator_pem']
  builder_pem delivery_databag['builder_pem']
  config node['delivery']['config']
  enterprise 'test'
  license 'cookbook_file://chef-services::delivery.license'
  accept_license node['chef-services']['accept_license']
  notifies :run, 'ruby_block[add automate password to databag]', :immediately
end

ruby_block 'add automate password to databag' do
  block do
    delivery_databag['automate_password'] = ::File.read('/etc/delivery/test.creds')[/Admin password: (?<pw>.*)$/, 'pw']

    @chef_rest = Chef::ServerAPI.new(
      Chef::Config[:chef_server_url],
      {
        client_name: 'delivery',
        signing_key_filename: '/etc/delivery/delivery.pem'
      }
    )

    @chef_rest.put('data/automate/automate', delivery_databag)
  end
  action :nothing
end
