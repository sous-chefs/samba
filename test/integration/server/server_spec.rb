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
  it { should exist }
end

describe file('/etc/samba/smb.conf') do
  it { should exist }
end

describe file('/etc/samba/smb.conf') do
  its('content') { should match %r{comment = exported share 1} }
  its('content') { should match %r{comment = exported share 2} }
  its('content') { should match %r{guest ok =} }
  its('content') { should_not match %r{guest_ok =} }
end
