
chef_server_user 'delivery' do
  firstname 'Delivery'
  lastname 'User'
  email 'delivery@example.com'
  password 'delivery'
  private_key_path '/tmp/delivery.pem'
  action :create
end

chef_server_org 'chef_delivery' do
  org_long_name 'Chef Delivery Organization'
  org_private_key_path '/tmp/delivery-validator.pem'
  action :create
end

chef_server_org 'chef_delivery' do
  admins %w{ delivery }
  action :add_admin
end

file '/tmp/config.rb' do
  content <<-EOF
log_level                :info
log_location             STDOUT
node_name                "delivery"
client_key               "/tmp/delivery.pem"
validation_client_name   "chef_delivery-validator"
validation_key           "/tmp/delivery-validator.pem"
chef_server_url          "https://chef.example.com/organizations/chef_delivery"
cookbook_path            ["/tmp/kitchen/cookbooks"]
EOF
end

execute 'knife ssl fetch -c /tmp/config.rb'

execute 'knife upload cookbooks data_bags --chef-repo-path . -c ../config.rb' do
  cwd '/tmp/kitchen'
end