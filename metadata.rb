name             'samba'
maintainer       'Sous Chefs'
maintainer_email 'help@sous-chefs.org'
license          'Apache 2.0'
description      'Installs/Configures samba'
version          '1.0.4'

%w( debian ubuntu centos fedora redhat scientific amazon oracle ).each do |os|
  supports os
end

source_url 'https://github.com/sous-chefs/samba' if respond_to?(:source_url)
issues_url 'https://github.com/sous-chefs/samba/issues' if respond_to?(:issues_url)
chef_version '>= 12.5' if respond_to?(:chef_version)

depends 'compat_resource', '>= 12.16'
