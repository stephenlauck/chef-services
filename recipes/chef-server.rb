chef_server node['fqdn'] do
  config node['chef-server']['config']
  addons 'manage' => { config: node['manage']['config'] },
         'push-jobs-server' => { config: node['push-jobs-server']['config'] }
  accept_license node['chef-services']['accept_license']
  data_collector_url node['chef_automate']['fqdn']
end

chef_user 'delivery' do
  first_name 'Delivery'
  last_name 'User'
  email 'delivery@services.com'
  password 'delivery'
  key_path "#{node['chef_server']['install_dir']}/delivery.pem"
end

chef_org 'delivery' do
  org_full_name 'Delivery Organization'
  key_path "#{node['chef_server']['install_dir']}/delivery-validator.pem"
  admins %w( delivery )
end

directory "#{node['chef_server']['install_dir']}/chef_installer/.chef/cache" do
  recursive true
end

chef_client node['fqdn'] do
  chef_server_url "https://#{node['chef_server']['fqdn']}/organizations/delivery"
  validation_client_name 'delivery-validator'
  validation_pem "file://#{node['chef_server']['install_dir']}/delivery-validator.pem"
  config "file_cache_path '#{node['chef_server']['install_dir']}/chef_installer/.chef/cache'"
  ssl_verify false
end

include_recipe 'chef-services::save_secrets'
