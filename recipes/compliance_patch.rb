# create a basic patch level scan compliance profile role and upload to chef-server
directory "#{node['chef_server']['install_dir']}/chef_installer/roles/" do
  action :create
  recursive true
end

file "#{node['chef_server']['install_dir']}/chef_installer/roles/patch.json" do
  content <<-EOD
  {
    "name": "patch",
    "description": "",
    "json_class": "Chef::Role",
    "default_attributes": {
      "audit": {
        "collector": "chef-server-visibility",
        "profiles": [
          {
            "name": "dev-sec/linux-patch-benchmark",
            "url": "https://github.com/dev-sec/linux-patch-benchmark"
          }
        ]
      },
      "chef-client": {
        "interval": "300"
      }
    },
    "chef_type": "role",
    "run_list": [
      "recipe[chef-client]",
      "recipe[audit]"
    ]
  }
  EOD
end

execute 'upload roles' do
  command 'knife upload roles'
  cwd "#{node['chef_server']['install_dir']}/chef_installer"
  environment 'PATH' => "/opt/chefdk/gitbin:#{ENV['PATH']}"
end
