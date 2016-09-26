directory "#{node['install_dir']}/chef_installer/cookbooks" do
  recursive true
end

file "#{node['install_dir']}/solo.rb" do
  content <<-EOF
cookbook_path '/tmp/chef_installer/cookbooks'
file_cache_path '#{node['install_dir']}/chef_installer'
EOF
end

package 'git'

file "#{node['install_dir']}/chef_installer/Berksfile" do
  content "source 'https://supermarket.chef.io'

cookbook 'chef-server-ctl', git: 'https://github.com/stephenlauck/chef-server-ctl.git'
cookbook 'chef-services', git: 'https://github.com/stephenlauck/chef-services.git', branch: 'ad/fixes'
cookbook 'chef-ingredient', git: 'https://github.com/chef-cookbooks/chef-ingredient.git'
cookbook 'test', git: 'https://github.com/stephenlauck/chef-services.git', branch: 'ad/fixes', rel: 'test/fixtures/cookbooks/test'"
end

execute 'berks update' do
  command 'berks update'
  cwd "#{node['install_dir']}/chef_installer"
  only_if do ::File.exists?("#{node['install_dir']}/chef_installer/Berksfile.lock") end
end

execute 'berks install' do
  command 'berks install'
  cwd "#{node['install_dir']}/chef_installer"
end

execute 'berks vendor' do
  command 'berks vendor cookbooks/'
  cwd "#{node['install_dir']}/chef_installer"
end
