name             'chef-splunk-windows'
maintainer       'Craig Beetlestome'
maintainer_email 'cbeetlestone@gmail.com'
license          'Apache-2.0'
description      'Installs and configures the Splunk Universal Forwarder on Windows servers'
long_description 'Installs and configures the Splunk Universal Forwarder on Windows servers'
source_url       'https://github.com/biola/chef-splunk-windows'
issues_url       'https://github.com/biola/chef-splunk-windows/issues'
version          '1.0.0'

supports windows
chef_version '~> 14'

depends          'chef-vault', '>= 3.1.0'
#depends          'windows', '~> 5.0'
