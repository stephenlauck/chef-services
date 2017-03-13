
execute 'create delivered environment' do
  command 'knife environment create delivered -d "Delivered"'
  cwd "#{node['chef_server']['install_dir']}/chef_installer"
  environment 'PATH' => "/opt/chefdk/gitbin:#{ENV['PATH']}"
end
