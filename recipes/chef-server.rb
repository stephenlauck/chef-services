remote_file "#{node['chef_server']['install_dir']}/chefdk.rpm" do
  source "http://omnitruck.chef.io/stable/chef-server/download?p=sles&pv=12&m=x86_64&v=latest"
end

chef_ingredient "chef-server" do
  config <<-EOS
api_fqdn "#{node['chef_server']['fqdn']}"

oc_id['applications'] = {
  "supermarket"=>{"redirect_uri"=>"https://supermarket.services.com/auth/chef_oauth2/callback"}
}
EOS
  action :upgrade
  version :latest
  source "#{node['chef_server']['install_dir']}/chefdk.rpm"
  accept_license true
end

ingredient_config "chef-server" do
  notifies :reconfigure, "chef_ingredient[chef-server]", :immediately
end

%w(manage push-jobs-server).each do |addon|
  chef_ingredient addon do
    accept_license true
  end

  ingredient_config addon do
    notifies :reconfigure, "chef_ingredient[#{addon}]", :immediately
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
