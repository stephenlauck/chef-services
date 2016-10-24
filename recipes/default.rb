#
# Cookbook Name:: chef-services
# Recipe:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

directory '/tmp/chef_installer'

cookbook_file '/tmp/chef_installer/installer.rb' do
  source 'installer.rb'
end

cookbook_file '/tmp/chef_installer/installer.sh' do
  source 'installer.sh'
  mode 0755
end

execute '/tmp/chef_installer/installer.sh'
