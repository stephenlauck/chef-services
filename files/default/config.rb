current_dir = File.dirname(__FILE__)
eval(IO.read('/etc/chef/client.rb'))
log_location STDOUT
node_name "delivery"
client_key "#{current_dir}/delivery.pem"
trusted_certs_dir "/etc/chef/trusted_certs"
