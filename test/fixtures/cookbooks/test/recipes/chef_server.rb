remote_file '/tmp/installer.sh' do
  source 'file:///tmp/kitchen/cookbooks/chef-services/files/default/installer.sh'
  mode 0755
end

execute 'install Chef server' do
  command './installer.sh -c chef.services.com'
  cwd '/tmp'
  action :run
end

file '/tmp/pre-delivery-validator.pub' do
  content <<-eos
-----BEGIN PUBLIC KEY-----
MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAuK094FPDVk8YgRxNyCsz
fpMwuoLinQGbDtHUtiqodVrJk5Q8PYN7f8K5tM61tPMv0VduCDahm7LXOLk/SWgI
lBFdBurrwMeIsRhoqohtsUW2qhaKSX6dhPjWjFAwP1C8WqjL9xuyWTMjS6hF2w6+
za43OLvV+srnoBPIcRDWqr/76IbO1RO+fgw1cX4FBPHp+rdJI/BjkufSQNGEQuWa
QDYv7ZGgCBgb0xtOEARlHZUWBCjcW6apMo6jKnOCEqvheN6PboSYXAITwueLdGB7
COOJxa9h3vZYI9jFqUKMMV/kTCls5KlnxI0ATDTeZ4Y9KASNISQQA0Sv0i1R28Oy
+wIDAQAB
-----END PUBLIC KEY-----
eos
end

execute 'add delivery validator' do
  command 'chef-server-ctl add-client-key delivery delivery-validator --public-key-path /tmp/pre-delivery-validator.pub'
  action :run
end
