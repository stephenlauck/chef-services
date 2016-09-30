directory '/var/log/push-jobs-client' do
  action :create
  recursive true
end

template '/etc/chef/push-jobs-client.rb' do
  source 'push-jobs-client.rb.erb'
end

case node['platform_family']
when 'ubuntu'
  init_template = 'push-jobs-client-upstart'
  init_file = '/etc/init/push-jobs-client.conf'
when 'rhel', 'suse'
  if node['platform_version'].to_i == 6
    init_template = 'push-jobs-client-rhel-6'
    init_file = '/etc/rc.d/init.d/push-jobs-client'
  else
    init_template = 'push-jobs-client-system-d'
    init_file = '/etc/systemd/system/push-jobs-client.service'
  end
else
  raise "Unsupported platform for build node"
end

template init_file do
  source init_template
  mode 0755
end

service 'push-jobs-client' do
  action [:enable, :start]
end
