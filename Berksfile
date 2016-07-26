source "https://supermarket.chef.io"

metadata

cookbook 'chef-server-ctl', git: 'https://github.com/stephenlauck/chef-server-ctl.git'
cookbook 'supermarket-omnibus-cookbook', git: 'https://github.com/chef-cookbooks/supermarket-omnibus-cookbook.git'
cookbook 'delivery-cluster', git: 'https://github.com/chef-cookbooks/delivery-cluster.git'
cookbook 'chef-server-12', git: 'https://github.com/chef-cookbooks/delivery-cluster.git', rel: 'vendor/chef-server-12'
cookbook 'delivery-base', git: 'https://github.com/chef-cookbooks/delivery-base.git'
cookbook 'delivery_build', git: 'https://github.com/chef-cookbooks/delivery_build.git'
cookbook 'push-jobs', git: 'https://github.com/chef-cookbooks/push-jobs.git'
cookbook 'chef-ingredient', git: 'https://github.com/chef-cookbooks/chef-ingredient.git'

group :integration do
  cookbook 'test', path: './test/fixtures/cookbooks/test'
end
