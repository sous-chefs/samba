execute 'apt-get update' if platform_family?('debian')

user 'smbuser' do
  comment 'Samba Test User'
  home '/home/smbuser'
  shell '/bin/bash'
end
