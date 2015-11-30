execute "scp -i /root/.ssh/insecure_private_key -o StrictHostKeyChecking=no -r root@chef.services.com:/tmp/delivery-validator.pem /etc/chef/chef_delivery-validator.pem"

# copy delivery cert to build node trusted certs
execute "scp -i /root/.ssh/insecure_private_key -o StrictHostKeyChecking=no -r root@delivery.services.com:/var/opt/delivery/nginx/ca/delivery.services.com.crt /etc/chef/trusted_certs/delivery.services.com.crt"


file '/etc/chef/client.rb' do
  content <<-EOF
log_level                :info
log_location             STDOUT
validation_client_name   "chef_delivery-validator"
validation_key           "/etc/chef/chef_delivery-validator.pem"
chef_server_url          "https://chef.services.com/organizations/chef_delivery"
encrypted_data_bag_secret "/tmp/kitchen/encrypted_data_bag_secret"
EOF
end

file '/etc/chef/dna.json' do
  content <<-EOF
{
    "delivery_build": {
        "trusted_certs": {
            "delivery server cert": "/etc/chef/trusted_certs/delivery.services.com.crt"
        }
    },
    "run_list": [
        "recipe[delivery_build]",
        "recipe[push-jobs]"
    ]
}
  EOF
end

execute 'cp /etc/delivery/builder_key /var/opt/delivery/workspace/etc'

execute 'cp /etc/delivery/delivery.pem /var/opt/delivery/workspace/etc'

execute 'cp /etc/delivery/builder_key /var/opt/delivery/workspace/.chef'

execute 'cp /etc/delivery/delivery.pem /var/opt/delivery/workspace/.chef'

execute 'knife ssl fetch -c /etc/chef/client.rb'

execute 'chef-client -j /etc/chef/dna.json'
