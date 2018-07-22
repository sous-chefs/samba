name             'samba'
maintainer       'Sous Chefs'
maintainer_email 'help@sous-chefs.org'
license          'Apache-2.0'
description      'Installs/Configures samba'
version          '1.1.4'
source_url       'https://github.com/sous-chefs/samba'
issues_url       'https://github.com/sous-chefs/samba/issues'
chef_version     '>= 12.16' if respond_to?(:chef_version)

%w(debian ubuntu centos fedora redhat scientific amazon oracle).each do |os|
  supports os
end
