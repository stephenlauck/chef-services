chef_ingredient 'delivery' do
  config <<-EOS
delivery_fqdn "#{node['delivery']['fqdn']}"

delivery['chef_username']    = "delivery"
delivery['chef_private_key'] = "/etc/delivery/delivery.pem"
delivery['chef_server']      = "#{node['delivery']['chef_server']}"

delivery['default_search']   = "((recipes:delivery_build OR tags:delivery-build-node OR recipes:delivery_build\\\\\\\\:\\\\\\\\:default) AND chef_environment:_default)"

insights['enable'] = true
  EOS
  version node['delivery']['version']
  action :install
end

ingredient_config "delivery" do
  notifies :reconfigure, "chef_ingredient[delivery]", :immediately
end


# build node

# install chefdk
chef_ingredient 'chefdk' do
  action :upgrade
  version :latest
end

# set chefdk as default
file node['chefdk']['bashrc'] do
  content lazy {
    txt = 'eval "$(chef shell-init bash)"'
    lines = ::File.read(node['chefdk']['bashrc']).split("\n")
    lines << txt unless lines.include?(txt)
    lines.join("\n")
  }
end
