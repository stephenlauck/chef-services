directory '/etc/chef/trusted_certs' do
  mode 00755
  recursive true
end

%W(#{node['chef_server']['fqdn']} #{node['chef_automate']['fqdn']}).each do |server|
  execute "fetch ssl cert for #{server}" do
    command "knife ssl fetch -s https://#{server}"
  end
  execute "fetch ssl cert for #{server}" do
    command "knife ssl fetch -s https://#{server} -c /etc/chef/client.rb"
  end
end

execute 'chmod trusted certs' do
  command 'chmod 0644 /etc/chef/trusted_certs/*'
end
