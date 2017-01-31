name             'chef-services'
maintainer       'The Authors'
maintainer_email 'you@example.com'
license          'all_rights'
description      'Installs/Configures chef-services'
long_description 'Installs/Configures chef-services'
version          '4.1.2'

depends 'ntp'
depends 'fancy_execute'
depends 'chef-server-ctl'
depends 'supermarket-omnibus-cookbook'

depends 'chef_stack'
