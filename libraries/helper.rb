def get_node_name_from_config
  node_line = File.foreach('/etc/chef/client.rb').grep(/^node_name/).last
  node_line.split(" ").last.gsub!(/\"|\\/, '')
end
