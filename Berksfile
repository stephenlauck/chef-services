source "https://supermarket.chef.io"

metadata

cookbook 'chef-server', git: 'https://github.com/stephenlauck/chef-server.git', branch: 'add_org_and_user'
cookbook 'chef-analytics', git: 'https://github.com/stephenlauck/chef-analytics.git'
cookbook 'supermarket-omnibus-cookbook', git: 'https://github.com/stephenlauck/supermarket-omnibus-cookbook.git', branch: 'template_supermarket_json'

group :integration do
  cookbook 'test', path: './test/fixtures/cookbooks/test'
end