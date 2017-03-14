# Package logic
# Since we're trying to keep this cookbook simple, and not use external API's
# to simplify the proxy story, we're setting package URL's in attributes.
# To make this work on more than one platform we're using some logic here.
#
# If you're overriding the package values you don't need to worry about this.
#
# pv = platform version
# pl = platform
# pf = package format
# s = seperator, we apparently use - for el and _ for ubuntu between the package
#     name and version.

case node['platform_family']
when 'rhel'
  pl = 'el'
  pv = node['platform_version'].to_i
  pf = ".#{pl}#{pv}.x86_64.rpm"
  s = '-'
when 'suse'
  pl = 'el'
  if node['platform_version'].to_i == 12
    pv = '7'
  else
    pv = '6'
  end
  pf = ".#{pl}#{pv}.x86_64.rpm"
  s = '-'
when 'debian'
  pl = 'ubuntu'
  pv = node['platform_version']
  pf = "_amd64.deb"
  s = "_"
else
  raise "You seem to be running on an unrecognized platform."
end

default['delivery']['version'] = "0.6.7-1"
default['chef-server']['version'] = "12.11.1-1"
default['manage']['version'] = "2.4.4-1"
default['push-jobs-server']['version'] = "2.1.0-1"
default['chefdk']['version'] = "1.0.3-1"
default['supermarket']['version'] = "2.8.34-1"
default['compliance']['version'] = "1.7.7-1"

%w(delivery chefdk chef-server manage push-jobs-server supermarket compliance).each do |pkg|
  case pkg
  when 'chef-server'
    pn = 'chef-server-core'
  when 'manage'
    pn = 'chef-manage'
  when 'push-jobs-server'
    pn = 'opscode-push-jobs-server'
  when 'compliance'
    pn = 'chef-compliance'
  else
    pn = pkg
  end
  v = node[pkg]['version']
  # Derive the package URL from platform (pl), platform version (pv), the
  # package name (pn), the package version (v), and package format (pf)
  default[pkg]['package_url'] = "https://packages.chef.io/files/stable/#{pn}/#{v.split('-').first}/#{pl}/#{pv}/#{pn}#{s}#{v}#{pf}"
end

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
compliance_profiles["enable"] = true
EOS

# Chef server attributes

default['chef_server']['fqdn'] = nil
default['chef-server']['config'] = <<-EOS
api_fqdn "#{node['chef_server']['fqdn']}"

oc_id['applications'] = {
"supermarket"=>{"redirect_uri"=>"https://supermarket.services.com/auth/chef_oauth2/callback"}
}
profiles["root_url"] = "https://automate.services.com/"
EOS

# ChefDK Attributes

# Supermarket Attributes

default['chef-supermarket']['supermarket']['verify_ssl'] = false
default['chef-services']['supermarket']['config'] = {}

# Compliance attributes
