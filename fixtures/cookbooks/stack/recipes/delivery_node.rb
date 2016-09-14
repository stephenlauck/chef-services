directory '/etc/chef' do
  mode 0755
  recursive true
end

execute "scp -i /root/.ssh/insecure_private_key -o StrictHostKeyChecking=no -r root@chef.services.com:/tmp/delivery-validator.pem /etc/chef/delivery-validator.pem"

file '/etc/chef/client.rb' do
  content <<-EOF
log_level                :info
log_location             STDOUT
validation_client_name   "delivery-validator"
validation_key           "/etc/chef/delivery-validator.pem"
chef_server_url          "https://chef.services.com/organizations/delivery"
encrypted_data_bag_secret "/tmp/kitchen/encrypted_data_bag_secret"
EOF
end

file '/etc/chef/dna.json' do
  content <<-EOF
{
    "delivery": {
        "fqdn": "automate.services.com",
        "chef_server": "https://chef.services.com/organizations/delivery"
    },
    "run_list": [
        "recipe[stack::hostsfile]",
        "recipe[stack::delivery_keys]",
        "recipe[stack::delivery]",
        "recipe[stack::create_enterprise]"
    ]
}
  EOF
end

execute 'knife ssl fetch -c /etc/chef/client.rb'

execute 'chef-client -j /etc/chef/dna.json'
