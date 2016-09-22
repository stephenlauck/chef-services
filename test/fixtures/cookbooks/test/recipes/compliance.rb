chef_ingredient 'compliance' do
	package_source node['compliance']['package_source']
	accept_license true
	action [:upgrade, :reconfigure]
end
