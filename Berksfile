source "https://supermarket.chef.io"

metadata

cookbook 'chef-server-ctl', git: 'https://github.com/stephenlauck/chef-server-ctl.git'
cookbook 'supermarket-omnibus-cookbook', git: 'https://github.com/chef-cookbooks/supermarket-omnibus-cookbook.git'

group :integration do
  cookbook 'test', path: './test/fixtures/cookbooks/test'
end

#cookbook 'chef_stack', git: 'https://github.com/ncerny/chef_stack.git', branch: 'lauck/fix_runner_knife_rb'
cookbook 'chef_stack', path: '../chef_stack'
