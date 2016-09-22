cookbook_file '/var/opt/delivery/license/delivery.license' do
  source 'delivery.license'
  owner 'root'
  group 'root'
  mode 00644
end
