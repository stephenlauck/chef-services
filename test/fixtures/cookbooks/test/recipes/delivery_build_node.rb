execute "scp -i /root/.ssh/insecure_private_key -o StrictHostKeyChecking=no -r root@chef.example.com:/tmp/delivery-validator.pem /etc/chef/chef_delivery-validator.pem"

file '/etc/chef/client.rb' do
  content <<-EOF
log_level                :info
log_location             STDOUT
validation_client_name   "chef_delivery-validator"
validation_key           "/etc/chef/chef_delivery-validator.pem"
chef_server_url          "https://chef.example.com/organizations/chef_delivery"
encrypted_data_bag_secret "/tmp/kitchen/encrypted_data_bag_secret"
EOF
end

file '/etc/chef/dna.json' do
  content <<-EOF
    {
    "run_list": ["recipe[delivery_build]", "recipe[push-jobs]"]
    }
  EOF
end

execute 'knife ssl fetch -c /etc/chef/client.rb'

execute 'chef-client -j /etc/chef/dna.json'
