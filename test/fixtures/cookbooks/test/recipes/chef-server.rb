%w( chef-server manage push-jobs-server ).each do |pkg|

  remote_file node[pkg]['package_source'] do
    source node[pkg]['package_url']
    only_if { node[pkg]['package_url'] }
  end

  chef_ingredient pkg do
    config node[pkg]['config']
    action :upgrade
    accept_license true
    package_source node[pkg]['package_source']
  end

  ingredient_config pkg do
    notifies :reconfigure, "chef_ingredient[#{pkg}]", :immediately
    only_if { node[pkg]['config'] }
  end

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
