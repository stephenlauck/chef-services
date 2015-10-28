source "https://supermarket.chef.io"

metadata

cookbook 'chef-server', git: 'https://github.com/stephenlauck/chef-server.git', branch: 'add_org_and_user'
cookbook 'chef-analytics', git: 'https://github.com/chef-cookbooks/chef-analytics.git'
cookbook 'supermarket-omnibus-cookbook', git: 'https://github.com/stephenlauck/supermarket-omnibus-cookbook.git', branch: 'template_supermarket_json'
cookbook 'delivery-cluster', git: 'https://github.com/stephenlauck/delivery-cluster.git', branch: 'deprecate_chef12'

cookbook 'delivery-base', git: 'https://github.com/chef-cookbooks/delivery-base.git'
cookbook 'delivery_build', git: 'https://github.com/chef-cookbooks/delivery_build.git'
cookbook 'omnibus', git: 'https://github.com/chef-cookbooks/omnibus.git'

group :integration do
  cookbook 'test', path: './test/fixtures/cookbooks/test'
end

