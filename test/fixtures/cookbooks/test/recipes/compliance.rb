chef_ingredient 'compliance' do
	channel node['compliance']['channel'].to_sym
	version node['compliance']['version']
	package_source node['compliance']['package_source']
    accept_license node['compliance']['accept_license'] unless node['compliance']['accept_license'].nil?
	action [:upgrade, :reconfigure]
end

execute 'chef-compliance-ctl user-create admin' do
    #this touch cmd feels a little hacky
    command 'chef-compliance-ctl user-create admin "password" && touch /etc/chef-compliance/admin-user-created'
    creates '/etc/chef-compliance/admin-user-created'
    action :run
    #this feels a little hacky
    not_if do ::File.exists?('/etc/chef-compliance/admin-user-created') end
end
