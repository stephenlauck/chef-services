#
# Cookbook Name:: chef-services
# Recipe:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

cookbook_file '~/installer.sh' do
  source 'installer.sh'
end
