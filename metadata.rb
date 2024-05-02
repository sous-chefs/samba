name             'samba'
maintainer       'Sous Chefs'
maintainer_email 'help@sous-chefs.org'
license          'Apache-2.0'
description      'Installs/Configures samba'
version          '2.0.11'
source_url       'https://github.com/sous-chefs/samba'
issues_url       'https://github.com/sous-chefs/samba/issues'
chef_version     '>= 15.3'

%w(debian ubuntu centos fedora redhat scientific amazon oracle).each do |os|
  supports os
end
