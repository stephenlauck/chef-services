require 'net/http'

def get_node_name_from_config
  node_line = File.foreach('/etc/chef/client.rb').grep(/^node_name/).last
  node_line.split(" ").last.gsub!(/\"|\\/, '')
end

def get_product_info(project, version, platform = node['platform'], platform_version = node['platform_version'], omnitruck_url = 'omnitruck.chef.io', channel = 'stable', arch="x86_64")
  pv = (node['platform'].eql?('ubuntu') ? node['platform_version'].delete('.') : node['platform_version'].to_i)
  url = URI.parse("http://#{omnitruck_url}/#{channel}/#{project}/metadata?p=#{platform}&pv=#{pv}&m=#{arch}&v=#{version}")
  request = Net::HTTP.new(url.host, url.port)
  res = request.get(url)
  dl_info = res.body.split("\n").map do |resource|
              resource = resource.split("\t")
            end
  dl_info = dl_info.to_h
  dl_info['name'] = File.basename(dl_info['url'])
  dl_info
end
