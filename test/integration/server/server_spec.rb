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
