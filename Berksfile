source "https://supermarket.chef.io"

metadata

cookbook 'chef-server-ctl', git: 'https://github.com/stephenlauck/chef-server-ctl.git'
cookbook 'supermarket-omnibus-cookbook', git: 'https://github.com/chef-cookbooks/supermarket-omnibus-cookbook.git'
cookbook 'chef-ingredient', git: 'https://github.com/chef-cookbooks/chef-ingredient.git'

group :integration do
  cookbook 'stack', path: './fixtures/cookbooks/stack'
end
