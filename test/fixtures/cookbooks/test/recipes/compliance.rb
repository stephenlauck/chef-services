chef_ingredient 'compliance' do
	channel node['compliance']['channel'].to_sym
	version node['compliance']['version']
	package_source node['compliance']['package_source']
	accept_license node['compliance']['accept_license'] unless node['compliance']['accept_license'].nil?
	action [:upgrade, :reconfigure]
end
