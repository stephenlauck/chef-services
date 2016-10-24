file_info = get_product_info("compliance", node['chef-services']['supermarket']['version'])

remote_file "#{Chef::Config[:file_cache_path]}/#{file_info['name']}" do
  source file_info['url']
  not_if { ::File.exist?("#{Chef::Config[:file_cache_path]}/#{file_info['name']}") }
end

chef_ingredient 'compliance' do
	package_source "#{Chef::Config[:file_cache_path]}/#{file_info['name']}"
	accept_license node['chef-services']['compliance']['accept_license'] unless node['compliance']['accept_license'].nil?
  action [:install,:reconfigure]
end

# Extra steps needed for SuSE

if node['platform'] == 'suse'

  user 'chef-compliance' do
    group 'chef-compliance'
    action :manage
  end

  user 'chef-pgsql' do
    group 'chef-compliance'
    action :manage
  end

  user 'dex-worker' do
    group 'dex-worker'
    action :manage
  end

  user 'dex-overlord' do
    group 'dex-overlord'
    action :manage
  end

  file '/etc/chef-compliance/server-config.json' do
    owner 'chef-compliance'
  end

  execute 'chown core' do
    command 'chown -R chef-compliance.chef-compliance /var/opt/chef-compliance/core'
    action :run
  end

  execute 'restart chef-compliance' do
    command 'chef-compliance-ctl restart'
  end

end
