describe port(445) do
  it { should be_listening }
end

describe port(139) do
  it { should be_listening }
end

describe command('pdbedit -Lv -u test_user_1') do
  its(:stdout) { should match(/Unix username.*test_user_1/) }
  its(:stdout) { should match(/Account Flags.*\[U/) }
end

describe user('test_user_1') do
  it { should exist }
end

describe directory('/home/test_user_1') do
  it { should exist }
end

describe user('test_user_2') do
  it { should exist }
end

describe directory('/srv/export') do
  it { should exist }
end

describe directory('/srv/export_2') do
  it { should_not exist }
end

describe file('/etc/samba/smb.conf') do
  it { should exist }
end

describe file('/etc/samba/smb.conf') do
  its('content') { should match /workgroup = HOME/ }
  its('content') { should match /server string = fat/ }
  its('content') { should match /security = user/ }
  its('content') { should match /map to guest = Bad User/ }
  its('content') { should match /interfaces = lo 127.0.0.1 enp\* eth\*/ }
  its('content') { should match %r{hosts allow = 192.168.1.0\/24} }
  its('content') { should match /load printers = no/ }
  its('content') { should match /passdb backend = tdbsam/ }
  its('content') { should match /dns proxy = no/ }
  its('content') { should match /comment = exported share 1/ }
  its('content') { should match /comment = exported share 2/ }
  its('content') { should match /guest ok =/ }
  its('content') { should_not match /guest_ok =/ }
  its('content') { should match /allow dns updates = secure only/ }
  its('content') { should match /allow insecure wide links = no/ }
end

case os['family']
when 'redhat'
  describe service('smb') do
    it { should be_installed }
    it { should be_enabled }
    it { should be_running }
  end

  describe service('nmb') do
    it { should be_installed }
    it { should be_enabled }
    it { should be_running }
  end
else
  describe service('smbd') do
    it { should be_installed }
    it { should be_enabled }
    it { should be_running }
  end

  describe service('nmbd') do
    it { should be_installed }
    it { should be_enabled }
    it { should be_running }
  end
end
