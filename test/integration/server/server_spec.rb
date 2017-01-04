describe port(445) do
  it { should be_listening }
end

describe port(139) do
  it { should be_listening }
end

describe command('pdbedit -Lv -u smbuser') do
  its(:stdout) { should match(/Unix username.*smbuser/) }
  its(:stdout) { should match(/Account Flags.*\[U/) }
end

describe user('test_user_1') do
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

options = {
  assignment_re: /^\s*([^:]*?)\s*:\s*(.*?)\s*$/,
  multiple_values: true
}
describe parse_config_file('/etc/samba/smb.conf', options) do
  its('comment') { should eq 'exported share 1' }
end
