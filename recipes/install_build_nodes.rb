case node['platform']
when 'ubuntu'
  chefdk_ext = 'deb'
else
  chefdk_ext = 'rpm'
end

remote_file "#{Chef::Config[:file_cache_path]}/chefdk.#{chefdk_ext}" do
  source node['chefdk']['source']
end

file '/etc/chef/validation.pem' do
  action :delete
end

node['chef_automate']['build_nodes'].each do |build_node|
  execute "Install build node #{build_node['fqdn']}" do
    command "delivery-ctl install-build-node --fqdn #{build_node['fqdn']} --username #{build_node['username']} --password #{build_node['password']} --installer #{Chef::Config[:file_cache_path]}/chefdk.#{chefdk_ext} --overwrite-registration"
    action :run
  end
end
