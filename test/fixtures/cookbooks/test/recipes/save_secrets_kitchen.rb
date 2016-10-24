
ruby_block 'save databag' do
  block do
    require 'json'
    databag_json = ::File.read("#{node['chef_server']['install_dir']}/chef_installer/data_bags/automate.json")

    databag_hash = JSON.parse(databag_json)

    automate_item = Chef::DataBagItem.new
    automate_item.data_bag('automate')
    automate_item.raw_data = databag_hash
    automate_item.save
  end
end
