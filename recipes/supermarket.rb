file_info = get_product_info("supermarket", node['chef-services']['supermarket']['version'])

remote_file "#{node['chef_server']['install_dir']}/#{file_info['name']}" do
  source file_info['url']
  not_if { ::File.exist?("#{node['chef_server']['install_dir']}/#{file_info['name']}") }
end

delivery_databag = data_bag_item('automate', 'automate')

supermarket_config = {
      'chef_server_url' => node['chef_server']['fqdn'],
      'chef_oauth2_app_id' => delivery_databag['supermarket_oauth2_app_id'],
      'chef_oauth2_secret' => delivery_databag['supermarket_oauth2_secret'],
      'chef_oauth2_verify_ssl' => node['chef-supermarket']['supermarket']['verify_ssl']
    }

chef_ingredient 'supermarket' do
  config JSON.pretty_generate(supermarket_config.merge(node['chef-services']['supermarket']['config']))
  ctl_command '/opt/supermarket/bin/supermarket-ctl'
  sensitive   true
  package_source "#{node['chef_server']['install_dir']}/#{file_info['name']}"
end
