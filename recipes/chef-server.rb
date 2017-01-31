chef_server node['chef_server']['fqdn'] do
  version :latest
  config <<-EOS
api_fqdn '#{node['chef_server']['fqdn']}'
oc_id['applications'] = {
  "supermarket"=>{"redirect_uri"=>"https://supermarket.services.com/auth/chef_oauth2/callback"}
}
EOS
  addons manage: { version: '2.4.3', config: '' },
         :"push-jobs-server" => { version: '2.1.0', config: '' }
  accept_license true
  # data_collector_url 'https://automate.services.com/data-collector/v0/' if search(:node, 'name:automate-centos-68', filter_result: { 'name' => ['name'] }) # ~FC003
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

chef_client node['chef_server']['fqdn'] do
  chef_server_url "https://#{node['chef_server']['fqdn']}/organizations/delivery"
  validation_client_name 'delivery-validator'
  validation_pem "file://#{node['chef_server']['install_dir']}/delivery-validator.pem"
  config "file_cache_path '#{node['chef_server']['install_dir']}/chef_installer/.chef/cache'"
  ssl_verify false
end

include_recipe 'chef-services::save_secrets'
