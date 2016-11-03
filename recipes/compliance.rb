
remote_file "compliance package" do
  path "#{node['chef_server']['install_dir']}/#{::File.basename(node['compliance']['package_url'])}"
  source node['compliance']['package_url']
  only_if { node['compliance']['package_url'] }
end

chef_ingredient "compliance" do
  config node['compliance']['config'] if node['compliance']['config']
  package_source "#{node['chef_server']['install_dir']}/#{::File.basename(node['compliance']['package_url'])}" if node['compliance']['package_url']
  accept_license node['chef-services']['accept_license']
  action :upgrade
end

ingredient_config "compliance" do
  notifies :reconfigure, "chef_ingredient[compliance]", :immediately
end

# Extra steps needed for SuSE

if node['platform'] == 'suse'

  user 'chef-compliance' do
    group 'chef-compliance'
    action :manage
  end

  user 'chef-pgsql' do
    group 'chef-compliance'
    action :manage
  end

  user 'dex-worker' do
    group 'dex-worker'
    action :manage
  end

  user 'dex-overlord' do
    group 'dex-overlord'
    action :manage
  end

  file '/etc/chef-compliance/server-config.json' do
    owner 'chef-compliance'
  end

  execute 'chown core' do
    command 'chown -R chef-compliance.chef-compliance /var/opt/chef-compliance/core'
    action :run
  end

  execute 'restart chef-compliance' do
    command 'chef-compliance-ctl restart'
  end

end
