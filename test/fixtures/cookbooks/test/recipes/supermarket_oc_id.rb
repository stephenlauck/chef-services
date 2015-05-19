
execute "scp -i /root/.ssh/insecure_private_key -o StrictHostKeyChecking=no -r root@chef.example.com:/etc/opscode/oc-id-applications/supermarket.json /tmp/"

template '/etc/supermarket/supermarket.json' do
  source 'supermarket.json.erb'
  owner 'root'
  group 'root'
  variables(
    lazy {
      {
        :chef_server_url => node['supermarket_omnibus']['chef_server_url'],
        :chef_oauth2_app_id => get_supermarket_attribute('uid'),
        :chef_oauth2_secret => get_supermarket_attribute('secret'),
        :chef_oauth2_verify_ssl => node['supermarket_omnibus']['chef_oauth2_verify_ssl']
      }
    }
  )
  action :create
  notifies :reconfigure, 'chef_server_ingredient[supermarket]'
end
