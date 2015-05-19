source "https://supermarket.chef.io"

metadata

cookbook 'chef-server', git: 'https://github.com/stephenlauck/chef-server.git', branch: 'add_org_and_user'
cookbook 'chef-analytics', git: 'https://github.com/stephenlauck/chef-analytics.git'
cookbook 'supermarket-omnibus-cookbook', git: 'https://github.com/stephenlauck/supermarket-omnibus-cookbook.git', branch: 'template_supermarket_json'
cookbook 'delivery-cluster', git: 'https://github.com/stephenlauck/delivery-cluster.git', branch: 'data_bag_error_handling'

cookbook 'chef-server-12', git: 'https://github.com/opscode-cookbooks/chef-server-12.git'

group :integration do
  cookbook 'test', path: './test/fixtures/cookbooks/test'
end