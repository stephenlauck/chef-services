source "https://supermarket.chef.io"

metadata

cookbook 'chef-server-ctl', git: 'https://github.com/stephenlauck/chef-server-ctl.git'
cookbook 'supermarket-omnibus-cookbook', git: 'https://github.com/chef-cookbooks/supermarket-omnibus-cookbook.git'
cookbook 'chef-ingredient', git: 'https://github.com/andy-dufour/chef-ingredient.git'

group :integration do
  cookbook 'test', path: './test/fixtures/cookbooks/test'
end

cookbook 'chef', git: 'https://github.com/ncerny/chef-cookbook.git'
