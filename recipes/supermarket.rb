delivery_databag = data_bag_item('automate', 'automate')

user 'supermarket' do
  group 'supermarket'
  only_if { node['platform'].eql?('suse') }
end

chef_supermarket 'supermarket.services.com' do
  chef_server_url "https://#{node['chef_server']['fqdn']}"
  chef_oauth2_app_id delivery_databag['supermarket_oauth2_app_id']
  chef_oauth2_secret delivery_databag['supermarket_oauth2_secret']
  chef_oauth2_verify_ssl node['chef-supermarket']['supermarket']['verify_ssl']
  config node['chef-services']['supermarket']['config']
  accept_license node['chef-services']['accept_license']
end
