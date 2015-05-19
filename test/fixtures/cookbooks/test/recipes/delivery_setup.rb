
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