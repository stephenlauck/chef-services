default['chef-server'] = {
  'package_url' => nil,
  'package_source' => nil,
  'config' => ''
}

default['manage'] = {
  'package_url' => nil,
  'package_source' => nil
}

default['push-jobs-server'] = {
  'package_url' => nil,
  'package_source' => nil
}

default['delivery'] = {
  'package_url' => nil,
  'package_source' => nil,
  'chef_server' => 'https://chef.services.com/organizations/delivery'
}

default['compliance'] = {
  'package_url' => nil,
  'package_source' => nil
}

default['chefdk'] = {
  'package_url' => nil,
  'package_source' => nil,
  'bashrc' => '/etc/bashrc'
}
