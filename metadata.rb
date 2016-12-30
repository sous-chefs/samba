name             'samba'
maintainer       'Sous Chefs'
maintainer_email 'help@sous-chefs.org'
license          'Apache 2.0'
description      'Installs/Configures samba'
version          '0.12.0'

recipe 'samba::default', 'Includes the samba::client recipe'
recipe 'samba::client', 'Installs smbclient package'
recipe 'samba::server', 'Installs samba server packages and configures smb.conf'

%w( debian ubuntu centos fedora redhat scientific amazon oracle ).each do |os|
  supports os
end
