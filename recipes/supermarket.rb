file_info = get_product_info("supermarket", node['chef-services']['supermarket']['version'])
node.default['supermarket_omnibus']['package_url'] = file_info['url']

delivery_databag = data_bag_item('automate', 'automate')

supermarket_server 'supermarket' do
  chef_server_url "https://#{node['chef_server']['fqdn']}"
  chef_oauth2_app_id delivery_databag['supermarket_oauth2_app_id']
  chef_oauth2_secret delivery_databag['supermarket_oauth2_app_id']
  chef_oauth2_verify_ssl node['supermarket_omnibus']['chef_oauth2_verify_ssl']
  config node['supermarket_omnibus']['config'].to_hash
end
