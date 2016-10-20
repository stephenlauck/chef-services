file_info = get_product_info("compliance", node['chef-services']['supermarket']['version'])

remote_file "#{Chef::Config[:file_cache_path]}/#{file_info['name']}" do
  source file_info['url']
  not_if { ::File.exist?("#{Chef::Config[:file_cache_path]}/#{file_info['name']}") }
end

user 'chef-compliance' do
  group 'chef-compliance'
  action :manage
end

chef_ingredient 'compliance' do
	package_source "#{Chef::Config[:file_cache_path]}/#{file_info['name']}"
	accept_license node['chef-services']['compliance']['accept_license'] unless node['compliance']['accept_license'].nil?
  action [:install,:reconfigure]
end
