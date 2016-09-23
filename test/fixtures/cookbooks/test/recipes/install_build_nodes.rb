remote_file '/tmp/chefdk.el6.x86_64.rpm' do
  source "http://omnitruck.chef.io/stable/chefdk/download?p=el&pv=6&m=x86_64&v=latest"
end

file '/etc/chef/validation.pem' do
  action :delete
end

node['chef_automate']['build_nodes'].each do |build_node|
  execute "Install build node #{build_node['fqdn']}" do
    command "delivery-ctl install-build-node --fqdn #{build_node['fqdn']} --username #{build_node['username']} --password #{build_node['password']} --installer /tmp/chefdk.el6.x86_64.rpm --overwrite-registration"
    action :run
  end
end
