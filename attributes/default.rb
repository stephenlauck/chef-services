# License attributes

default['chef-services']['accept_license'] = true

# Workflow attributes

default['chef_automate']['fqdn'] = nil
default['delivery']['config'] = <<-EOS
delivery_fqdn "#{node['chef_automate']['fqdn']}"
delivery['chef_username']    = "delivery"
delivery['chef_private_key'] = "/etc/delivery/delivery.pem"
delivery['chef_server']      = "https://#{node['chef_server']['fqdn']}/organizations/delivery"
delivery['default_search']   = "tags:delivery-build-node"
insights['enable']           = true
EOS

default['delivery']['package_url'] = "https://packages.chef.io/files/stable/delivery/0.5.432/el/6/delivery-0.5.432-1.el6.x86_64.rpm"


# Chef server attributes

default['chef_server']['fqdn'] = nil
default['chef-server']['config'] = <<-EOS
api_fqdn "#{node['chef_server']['fqdn']}"

oc_id['applications'] = {
"supermarket"=>{"redirect_uri"=>"https://supermarket.services.com/auth/chef_oauth2/callback"}
}
EOS

default['chef-server']['package_url'] = "https://packages.chef.io/files/stable/chef-server/12.10.0/el/6/chef-server-core-12.10.0-1.el6.x86_64.rpm"
default['manage']['package_url'] = "https://packages.chef.io/files/stable/chef-manage/2.4.4/el/6/chef-manage-2.4.4-1.el6.x86_64.rpm"
default['push-jobs-server']['package_url'] = "https://packages.chef.io/files/stable/opscode-push-jobs-server/2.1.0/el/6/opscode-push-jobs-server-2.1.0-1.el6.x86_64.rpm"
default['reporting']['package_url'] = "https://packages.chef.io/files/stable/opscode-reporting/1.6.4/el/6/opscode-reporting-1.6.4-1.el6.x86_64.rpm"


# ChefDK Attributes

default['chefdk']['package_url'] = "https://packages.chef.io/files/stable/chefdk/0.19.6/el/6/chefdk-0.19.6-1.el6.x86_64.rpm"

# Supermarket Attributes

default['chef-supermarket']['supermarket']['verify_ssl'] = false
default['chef-services']['supermarket']['config'] = {}
default['supermarket']['package_url'] = "https://packages.chef.io/files/stable/supermarket/2.8.30/el/6/supermarket-2.8.30-1.el6.x86_64.rpm"

# Compliance attributes

default['compliance']['package_url'] = "https://packages.chef.io/files/stable/chef-compliance/1.6.8/el/6/chef-compliance-1.6.8-1.el6.x86_64.rpm"
