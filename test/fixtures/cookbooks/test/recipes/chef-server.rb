chef_ingredient "chef-server" do
  config <<-EOS
api_fqdn "chef.services.com"

oc_id['applications'] = {
  "supermarket"=>{"redirect_uri"=>"https://supermarket.services.com/auth/chef_oauth2/callback"}
}
EOS
  action :upgrade
  version :latest
  accept_license true
  package_source node['chef-server']['package_source']
end

ingredient_config "chef-server" do
  notifies :reconfigure, "chef_ingredient[chef-server]", :immediately
end

%w( manage ).each do |addon|
  chef_ingredient addon do
    accept_license true
  end

  ingredient_config addon do
    notifies :reconfigure, "chef_ingredient[#{addon}]", :immediately
  end
end

# download and install push-jobs-server
remote_file '/tmp/opscode-push-jobs-server-1.1.6-1.x86_64.rpm' do
  source 'https://bintray.com/chef/stable/download_file?file_path=el%2F6%2Fopscode-push-jobs-server-1.1.6-1.x86_64.rpm'
end

chef_ingredient 'push-jobs-server' do
  accept_license true
  version '1.1.6-1'
  package_source '/tmp/opscode-push-jobs-server-1.1.6-1.x86_64.rpm'
  notifies :reconfigure, "chef_ingredient[push-jobs-server]"
end

chef_server_user 'delivery' do
  firstname 'Delivery'
  lastname 'User'
  email 'delivery@services.com'
  password 'delivery'
  private_key_path '/tmp/delivery.pem'
  action :create
end

chef_server_org 'delivery' do
  org_long_name 'Delivery Organization'
  org_private_key_path '/tmp/delivery-validator.pem'
  action :create
end

chef_server_org 'delivery' do
  admins %w{ delivery }
  action :add_admin
end

file '/tmp/config.rb' do
  content <<-EOF
log_level                :info
log_location             STDOUT
node_name                "delivery"
client_key               "/tmp/delivery.pem"
validation_client_name   "delivery-validator"
validation_key           "/tmp/delivery-validator.pem"
chef_server_url          "https://chef.services.com/organizations/delivery"
cookbook_path            ["/tmp/kitchen/cookbooks"]
EOF
end

execute 'knife ssl fetch -c /tmp/config.rb'

# execute 'knife upload cookbooks data_bags --chef-repo-path . -c ../config.rb' do
execute 'knife cookbook upload -a cookbooks -c ../config.rb && knife upload data_bags --chef-repo-path . -c ../config.rb' do
  cwd '/tmp/kitchen'
end
