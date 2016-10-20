file_info = get_product_info("compliance", node['chef-services']['supermarket']['version'])

remote_file "#{Chef::Config[:file_cache_path]}/#{file_info['name']}" do
  source file_info['url']
  not_if { ::File.exist?("#{Chef::Config[:file_cache_path]}/#{file_info['name']}") }
end

chef_ingredient 'compliance' do
	package_source "#{Chef::Config[:file_cache_path]}/#{file_info['name']}"
	accept_license node['chef-services']['compliance']['accept_license'] unless node['compliance']['accept_license'].nil?
end

user 'chef-compliance' do
  group 'chef-compliance'
  action :manage
end

ingredient_config 'compliance' do
  notifies :reconfigure, 'chef_ingredient[compliance]', :immediately
end
