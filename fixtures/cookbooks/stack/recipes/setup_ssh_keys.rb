# set up shared vagrant keys in order to copy files across chef services

directory '/root/.ssh' do
  action :create
  owner 'root'
  group 'root'
  mode '0700'
end

cookbook_file '/root/.ssh/insecure_private_key' do
  action :create
  owner 'root'
  group 'root'
  mode '0600'
  source 'insecure_private_key'
end

cookbook_file '/root/.ssh/authorized_keys' do
  action :create
  owner 'root'
  group 'root'
  mode '0600'
  source 'insecure_public_key'
end
