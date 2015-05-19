execute 'chef-server-ctl restart' do
  action :nothing
end

chef_server_user 'flock' do
  firstname 'Florian'
  lastname 'Lock'
  email 'ops@example.com'
  password 'DontUseThis4Real'
  private_key_path '/tmp/flock.pem'
  action :create
end

chef_server_org 'example' do
  org_long_name 'Example Organization'
  org_private_key_path '/tmp/example-validator.pem'
  action :create
end

chef_server_org 'example' do
  admins %w{ flock }
  action :add_admin
  notifies :run, 'execute[chef-server-ctl restart]'
end