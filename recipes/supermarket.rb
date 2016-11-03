
remote_file "supermarket package" do
  path "#{node['chef_server']['install_dir']}/#{::File.basename(node['supermarket']['package_url'])}"
  source node['supermarket']['package_url']
  only_if { node['supermarket']['package_url'] }
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
  package_source "#{node['chef_server']['install_dir']}/#{::File.basename(node['supermarket']['package_url'])}" if node['supermarket']['package_url']
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
