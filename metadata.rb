name             'samba'
maintainer       'Sous Chefs'
maintainer_email 'help@sous-chefs.org'
license          'Apache 2.0'
description      'Installs/Configures samba'
version          '0.13.0'

recipe 'samba::default', 'Includes the samba::client recipe'
recipe 'samba::client', 'Installs smbclient package'
recipe 'samba::server', 'Installs samba server packages and configures smb.conf'

%w( debian ubuntu centos fedora redhat amazon ).each do |os|
  supports os
end

source_url 'https://github.com/sous-chefs/samba'
issues_url 'https://github.com/sous-chefs/samba/issues'
chef_version '>= 12.1' if respond_to?(:chef_version)

depends 'compat_resource', '>= 12.16.3'
