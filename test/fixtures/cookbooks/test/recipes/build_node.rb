execute 'build node asking to configure itself from Automate' do
  command <<-EOD
ssh -i /root/.ssh/insecure_private_key -o StrictHostKeyChecking=no root@automate.services.com delivery-ctl install-build-node --fqdn build.services.com \
--username vagrant \
--password vagrant \
--installer /tmp/kitchen/cache/chefdk-0.16.28-1.el7.x86_64.rpm \
--overwrite-registration \
--port 22
EOD
end
