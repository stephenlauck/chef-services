execute 'delivery-ctl reconfigure' do
  action :nothing
end

cache_path = Chef::Config[:file_cache_path]

file "#{cache_path}/delivery.firstrun" do
  action :create
  not_if do ::File.exists?("#{cache_path}/delivery.firstrun") || !::File.exists?("/var/opt/delivery/license/delivery.license") end
  notifies :run, 'execute[delivery-ctl reconfigure]', :immediately
end

execute 'create test enterprise' do
  command 'delivery-ctl create-enterprise test --ssh-pub-key-file=/etc/delivery/builder_key.pub > /tmp/test.creds'
  not_if "delivery-ctl list-enterprises --ssh-pub-key-file=/etc/delivery/builder_key.pub | grep -w test"
end
