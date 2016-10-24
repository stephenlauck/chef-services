#TODO: Replace with chef vault or similar. Non-encrypted databags == bad.
require 'json'
require 'net/ssh'
require 'base64'

file_info = get_product_info("chefdk", node['chef-services']['chefdk']['version'])

remote_file "#{node['chef_server']['install_dir']}/#{file_info['name']}" do
  source file_info['url']
  not_if { ::File.exist?("#{node['chef_server']['install_dir']}/#{file_info['name']}") }
end

chef_ingredient 'chefdk' do
  package_source "#{node['chef_server']['install_dir']}/#{file_info['name']}"
end

directory "#{node['chef_server']['install_dir']}/chef_installer/.chef/" do
  action :create
  recursive true
end

file "#{node['chef_server']['install_dir']}/chef_installer/.chef/knife.rb" do
  content "
node_name                \"delivery\"
client_key               \"#{node['chef_server']['install_dir']}/delivery.pem\"
chef_server_url          \"https://#{node['chef_server']['fqdn']}/organizations/delivery\"
cookbook_path            [\"#{node['chef_server']['install_dir']}/chef_installer/cookbooks\"]
ssl_verify_mode          :verify_none
"
end
automate_db = begin
                data_bag('automate')
              rescue Net::HTTPServerException, Chef::Exceptions::InvalidDataBagPath
                nil # empty array for length comparison
              end

unless automate_db
  builder_key = OpenSSL::PKey::RSA.new(2048)

  directory "#{node['chef_server']['install_dir']}/chef_installer/data_bags"

  ruby_block 'write_automate_databag' do
    block do
      supermarket_ocid = JSON.parse(::File.read('/etc/opscode/oc-id-applications/supermarket.json'))

      automate_db_item = {
        'id' => 'automate',
        'validator_pem' => ::File.read("#{node['chef_server']['install_dir']}/delivery-validator.pem"),
        'user_pem' => ::File.read("#{node['chef_server']['install_dir']}/delivery.pem"),
        'builder_pem' => builder_key.to_pem,
        'builder_pub' => "ssh-rsa #{[builder_key.to_blob].pack('m0')}",
        'license_file' => Base64.encode64(::File.read('/var/opt/delivery/license/delivery.license')),
        'supermarket_oauth2_app_id' => supermarket_ocid['uid'],
        'supermarket_oauth2_secret' => supermarket_ocid['secret']
      }
      ::File.write("#{node['chef_server']['install_dir']}/chef_installer/data_bags/automate.json", automate_db_item.to_json)
      chef_server_install_dir = '/tmp/chef_installer'
    end
    not_if { ::File.exist?("#{node['chef_server']['install_dir']}/chef_installer/data_bags/automate.json") }
  end

  execute 'upload databag' do
    command 'knife data bag create automate;knife data bag from file automate data_bags/automate.json'
    cwd "#{node['chef_server']['install_dir']}/chef_installer"
    environment 'PATH' => "/opt/chefdk/gitbin:#{ENV['PATH']}"
  end

  file "#{node['chef_server']['install_dir']}/chef_installer/Berksfile" do
    content <<-EOF
  source 'https://supermarket.chef.io'

  cookbook 'chef-server-ctl', git: 'https://github.com/stephenlauck/chef-server-ctl.git'
  cookbook 'chef-services', git: 'https://github.com/stephenlauck/chef-services.git'
  cookbook 'chef-ingredient', git: 'https://github.com/andy-dufour/chef-ingredient.git'
  cookbook 'supermarket-omnibus-cookbook'
  EOF
  end

  execute 'upload cookbooks' do
    command 'berks install;berks upload --no-ssl-verify'
    cwd "#{node['chef_server']['install_dir']}/chef_installer"
    environment 'PATH' => "/opt/chefdk/gitbin:#{ENV['PATH']}"
  end
end
