delivery_databag = data_bag_item('automate', 'automate')

workflow_builder node['fqdn'] do
  accept_license true
  chef_user 'delivery'
  chef_user_pem delivery_databag['user_pem']
  builder_pem delivery_databag['builder_pem']
  chef_fqdn node['chef_server']['fqdn']
  automate_fqdn node['chef_automate']['fqdn']
  supermarket_fqdn 'supermarket.services.com'
  job_dispatch_version 'v2'
  automate_user 'admin'
  automate_password delivery_databag['automate_password']
  automate_enterprise 'test'
  platform 'el' if node['platform'] == 'suse'
  platform_version '6' if node['platform'] == 'suse'
end
