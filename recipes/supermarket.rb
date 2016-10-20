file_info = get_product_info("supermarket", node['chef-services']['supermarket']['version'])

remote_file "#{Chef::Config[:file_cache_path]}/#{file_info['name']}" do
  source file_info['url']
  not_if { ::File.exist?("#{Chef::Config[:file_cache_path]}/#{file_info['name']}") }
end

delivery_databag = data_bag_item('automate', 'automate')

supermarket_config = {
      'chef_server_url' => "https://#{node['chef_server']['fqdn']}",
      'chef_oauth2_app_id' => delivery_databag['supermarket_oauth2_app_id'],
      'chef_oauth2_secret' => delivery_databag['supermarket_oauth2_secret'],
      'chef_oauth2_verify_ssl' => node['chef-supermarket']['supermarket']['verify_ssl']
    }

chef_ingredient 'supermarket' do
  config JSON.pretty_generate(supermarket_config.merge(node['chef-services']['supermarket']['config']))
  ctl_command '/opt/supermarket/bin/supermarket-ctl'
  sensitive   true
  package_source "#{Chef::Config[:file_cache_path]}/#{file_info['name']}"
end

ingredient_config 'supermarket' do
  notifies :reconfigure, 'chef_ingredient[supermarket]', :immediately
end

if node['platform'] == 'suse'
  user 'supermarket' do
    group 'supermarket'
    action :manage
    notifies :reconfigure, 'chef_ingredient[supermarket]', :immediately
  end
end
