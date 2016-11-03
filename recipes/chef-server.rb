%w( chef-server manage push-jobs-server chefdk ).each do |svc|
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

wait_for_server_startup "wait"

# Even with our wait_for_server_startup resource, we can hit a race condition.
# For now I've added an arbitraty 10 seconds.

# TODO: make this less awful.

ruby_block 'wait' do
  block do
    sleep 10
  end
end

chef_server_user 'delivery' do
  firstname 'Delivery'
  lastname 'User'
  email 'delivery@services.com'
  password 'delivery'
  private_key_path "#{node['chef_server']['install_dir']}/delivery.pem"
  action :create
end

chef_server_org 'delivery' do
  org_long_name 'Delivery Organization'
  org_private_key_path "#{node['chef_server']['install_dir']}/delivery-validator.pem"
  action :create
end

chef_server_org 'delivery' do
  admins %w{ delivery }
  action :add_admin
end

directory '/etc/chef'

directory "#{node['chef_server']['install_dir']}/chef_installer/.chef/cache" do
  recursive true
end

file '/etc/chef/client.rb' do
  content <<-EOF
chef_server_url  "https://#{node['chef_server']['fqdn']}/organizations/delivery"
validation_client_name "delivery-validator"
validation_key "#{node['chef_server']['install_dir']}/delivery-validator.pem"
file_cache_path "#{node['chef_server']['install_dir']}/chef_installer/.chef/cache"
ssl_verify_mode :verify_none
EOF
end

include_recipe 'chef-services::delivery_license'
include_recipe 'chef-services::save_secrets'
