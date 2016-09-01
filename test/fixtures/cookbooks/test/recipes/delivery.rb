%w( delivery chefdk ).each do |pkg|

  remote_file node[pkg]['package_source'] do
    source node[pkg]['package_url']
    only_if { node[pkg]['package_url'] }
  end

  chef_ingredient pkg do
    config node[pkg]['config']
    action :upgrade
    accept_license true
    package_source node[pkg]['package_source']
  end

  ingredient_config pkg do
    notifies :reconfigure, "chef_ingredient[#{pkg}]", :immediately
    only_if { node[pkg]['config'] }
  end

end

execute 'create test enterprise' do
  command 'delivery-ctl create-enterprise test --ssh-pub-key-file=/etc/delivery/builder_key.pub > /tmp/test.creds'
  not_if "delivery-ctl list-enterprises --ssh-pub-key-file=/etc/delivery/builder_key.pub | grep -w test"
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
