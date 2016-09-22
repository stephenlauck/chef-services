file '/var/opt/delivery/license/delivery.license' do
  content Base64.decode64(delivery_databag['license_file'])
  owner 'root'
  group 'root'
  mode 00644
end
