# replicate /etc/opscode from bootstrap backend to frontend server

include_recipe 'test::setup_ssh_keys'

execute "scp -i /root/.ssh/insecure_private_key -o StrictHostKeyChecking=no -r root@33.33.33.12:/etc/opscode /etc/"