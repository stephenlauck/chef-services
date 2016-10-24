directory "#{node['install_dir']}/chef_installer/cookbooks" do
  recursive true
end

file "#{node['install_dir']}/solo.rb" do
  content <<-EOF
cookbook_path "#{node['install_dir']}/chef_installer/cookbooks"
file_cache_path "#{node['install_dir']}/chef_installer/.chef/cache"
EOF
end

file "#{node['install_dir']}/chef_installer/Berksfile" do
  content <<-EOF
source 'https://supermarket.chef.io'

cookbook 'chef-server-ctl', git: 'https://github.com/stephenlauck/chef-server-ctl.git'
cookbook 'chef-services', git: 'https://github.com/stephenlauck/chef-services.git'
cookbook 'chef-ingredient', git: 'https://github.com/andy-dufour/chef-ingredient.git'
EOF
end

execute 'berks update' do
  command 'berks update'
  cwd "#{node['install_dir']}/chef_installer"
  only_if do ::File.exists?("#{node['install_dir']}/chef_installer/Berksfile.lock") end
  environment 'PATH' => "/opt/chefdk/gitbin:#{ENV['PATH']}"
end

execute 'berks install' do
  command 'berks install'
  cwd "#{node['install_dir']}/chef_installer"
  environment 'PATH' => "/opt/chefdk/gitbin:#{ENV['PATH']}"
end

execute 'berks vendor' do
  command 'berks vendor cookbooks/'
  cwd "#{node['install_dir']}/chef_installer"
  environment 'PATH' => "/opt/chefdk/gitbin:#{ENV['PATH']}"
end
