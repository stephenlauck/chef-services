chef_ingredient 'delivery' do
  config <<-EOS
delivery_fqdn "#{node['delivery']['fqdn']}"

delivery['chef_username']    = "delivery"
delivery['chef_private_key'] = "/etc/delivery/delivery.pem"
delivery['chef_server']      = "#{node['delivery']['chef_server']}"

delivery['default_search']   = "((recipes:delivery_build OR recipes:delivery_build\\\\:\\\\:default) AND chef_environment:_default)"
  EOS
  channel :stable
  version node['delivery']['version']
  action :install
end

ingredient_config "delivery" do
  notifies :reconfigure, "chef_ingredient[delivery]", :immediately
end