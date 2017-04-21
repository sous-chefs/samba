apt_update 'update'

samba_server 'server' do
  server_string 'fat'
  workgroup 'HOME'
  interfaces 'lo 127.0.0.1 enp* eth*'
  hosts_allow '192.168.1.0/24'
  security 'user'
  passdb_backend 'tdbsam'
  socket_options 'TCP_NODELAY SO_RCVBUF=8192 SO_SNDBUF=8192'
  options 'allow dns updates' => 'secure only',
          'allow insecure wide links' => 'no'
end

samba_user 'test_user_1' do
  password 'superawesomepassword'
  comment 'Samba Test User'
  home '/home/test_user_1'
  shell '/bin/bash'
end

samba_user 'test_user_2' do
  password 'anothertopsecretpassword'
  comment 'Samba Test User'
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
  create_directory false
end
