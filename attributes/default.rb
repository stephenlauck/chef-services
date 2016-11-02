default['delivery']['version'] = 'latest'
default['delivery']['chef_server'] = 'https://chef.services.com/organizations/delivery'
default['chef_server']['fqdn'] = nil
default['compliance']['version'] = 'latest'
default['compliance']['package_source'] = nil
default['compliance']['channel'] = :stable
default['compliance']['accept_license'] = false
default['chef_automate']['fqdn'] = 'automate.services.com'
default['chefdk']['bashrc'] = '/etc/bashrc'
default['chef-services']['chefdk']['version'] = 'latest'
default['chef-services']['chef-server']['version'] = 'latest'
default['chef-services']['manage']['version'] = 'latest'
default['chef-services']['push-jobs-server']['version'] = 'latest'
default['chef-services']['delivery']['version'] = 'latest'
default['chef-services']['supermarket']['version'] = 'latest'
default['chef-services']['compliance']['version'] = 'latest'
default['chef-services']['compliance']['accept_license'] = true
default['chef-supermarket']['supermarket']['verify_ssl'] = false
default['chef-services']['supermarket']['config'] = {}
default['delivery']['config'] = <<-EOS
delivery_fqdn "#{node['chef_automate']['fqdn']}"
delivery['chef_username']    = "delivery"
delivery['chef_private_key'] = "/etc/delivery/delivery.pem"
delivery['chef_server']      = "https://#{node['chef_server']['fqdn']}/organizations/delivery"
delivery['default_search']   = "tags:delivery-build-node"
insights['enable']           = true
EOS

default['chef-server']['config'] = <<-EOS
api_fqdn "#{node['chef_server']['fqdn']}"

oc_id['applications'] = {
"supermarket"=>{"redirect_uri"=>"https://supermarket.services.com/auth/chef_oauth2/callback"}
}
EOS
