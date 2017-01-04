apt_update 'update' if platform_family?('debian')

user 'test_user_1' do
  comment 'Samba Test User'
  home '/home/smbuser'
  shell '/bin/bash'
end

user 'test_user_2' do
  comment 'Samba Test User'
  home '/home/smbuser'
  shell '/bin/bash'
end

samba_share 'first_share' do
  comment 'exported share 1'
  path '/srv/export'
  guest_ok 'no'
  printable 'no'
  write_list ['test_user_1']
  create_mask '0644'
  directory_mask '0775'
end

samba_share 'second_share' do
  comment 'exported share 2'
  path '/srv/export_2'
  guest_ok 'no'
  printable 'no'
  write_list ['test_user_2']
  create_mask '0644'
  directory_mask '0775'
end

samba_server 'Samba Server' do
end
