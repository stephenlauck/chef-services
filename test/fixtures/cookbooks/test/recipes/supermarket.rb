
execute "scp -i /root/.ssh/insecure_private_key -o StrictHostKeyChecking=no -r root@chef.services.com:/etc/opscode/oc-id-applications/supermarket.json /tmp/"

supermarket_server 'supermarket' do
  chef_server_url node['supermarket_omnibus']['chef_server_url']
  chef_oauth2_app_id lazy { get_supermarket_attribute('uid') }
  chef_oauth2_secret lazy { get_supermarket_attribute('secret') }
  chef_oauth2_verify_ssl node['supermarket_omnibus']['chef_oauth2_verify_ssl']
  config node['supermarket_omnibus']['config'].to_hash
end