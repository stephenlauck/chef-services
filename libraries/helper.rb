require 'net/http'

def get_node_name_from_config
  node_line = File.foreach('/etc/chef/client.rb').grep(/^node_name/).last
  node_line.split(" ").last.gsub!(/\"|\\/, '')
end

def get_product_info(project, version, platform = node['platform'], platform_version = node['platform_version'], omnitruck_url = 'omnitruck.chef.io', channel = 'stable', arch="x86_64")
  case platform
  when "ubuntu"
    pv = platform_version.delete('.')
  else
    pv = platform_version.to_i
  end
  url = URI.parse("http://#{omnitruck_url}/#{channel}/#{project}/metadata?p=#{platform}&pv=#{pv}&m=#{arch}&v=#{version}")
  res = Net::HTTP.get(url)
  dl_info = res.split("\n").map do |resource|
              resource = resource.split("\t")
            end
  dl_info = dl_info.to_h
  dl_info['name'] = File.basename(dl_info['url'])

  dl_info
end
