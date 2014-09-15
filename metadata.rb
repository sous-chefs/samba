name             'samba'
maintainer       'Joshua Timberman'
maintainer_email 'cookbooks@housepub.org'
license          'Apache 2.0'
description      'Installs/Configures samba'
version          '0.12.0'

recipe 'samba::default', 'Includes the samba::client recipe'
recipe 'samba::client', 'Installs smbclient package'
recipe 'samba::server', 'Installs samba server packages and configures smb.conf'

%w{ arch debian ubuntu centos fedora redhat scientific amazon raspbian }.each do |os|
  supports os
end
