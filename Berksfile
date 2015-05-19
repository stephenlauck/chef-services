source "https://supermarket.chef.io"

metadata

cookbook 'chef-server', git: 'https://github.com/chef-cookbooks/chef-server.git'
cookbook 'chef-analytics', path: '../chef-analytics'
cookbook 'supermarket-omnibus-cookbook', git: 'https://github.com/stephenlauck/supermarket-omnibus-cookbook.git', branch: 'template_supermarket_json'

group :integration do
  cookbook 'test', path: './test/fixtures/cookbooks/test'
end