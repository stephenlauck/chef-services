source "https://supermarket.chef.io"

metadata

cookbook 'chef-server'
cookbook 'chef-server-ctl', git: 'https://github.com/stephenlauck/chef-server-ctl.git'
cookbook 'chef-analytics', git: 'https://github.com/chef-cookbooks/chef-analytics.git'
cookbook 'supermarket-omnibus-cookbook', git: 'https://github.com/stephenlauck/supermarket-omnibus-cookbook.git', branch: 'template_supermarket_json'
cookbook 'delivery-cluster', git: 'https://github.com/stephenlauck/delivery-cluster.git', branch: 'deprecate_chef12'

cookbook 'delivery-base', git: 'https://github.com/chef-cookbooks/delivery-base.git'
cookbook 'delivery_build', git: 'https://github.com/chef-cookbooks/delivery_build.git', ref: '93d43869df526789cb95189ea2ac44276a47b6e0'
cookbook 'omnibus', git: 'https://github.com/chef-cookbooks/omnibus.git'

group :integration do
  cookbook 'test', path: './test/fixtures/cookbooks/test'
end

