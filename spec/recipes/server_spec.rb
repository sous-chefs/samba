require_relative '../spec_helper'

describe 'samba::server' do
  let(:shellout) { double('shellout') }

  allow(Mixlib::ShellOut).to receive(:new).and_return(shellout)
  allow(shellout).to receive(:stdout).and_return('')
  allow(shellout).to receive(:live_stream).and_return(STDOUT)
  allow(shellout).to receive(:run_command).and_return(nil)
end

context 'ubuntu' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(
      platform: 'ubuntu',
      version: '14.04'
    ).converge(described_recipe)
  end

  it 'installs samba' do
    expect(chef_run).to install_package 'samba'
  end

  it 'manages smb.conf' do
    expect(chef_run).to create_template('/etc/samba/smb.conf')
  end

  it 'notifies samba services to restart when updating the config' do
    resource = chef_run.template('/etc/samba/smb.conf')
    expect(resource).to notify('service[smbd]').to(:restart)
    expect(resource).to notify('service[nmbd]').to(:restart)
  end

  it 'manages the samba service(s)' do
    expect(chef_run).to enable_service('smbd')
    expect(chef_run).to enable_service('nmbd')
    expect(chef_run).to start_service('smbd')
    expect(chef_run).to start_service('nmbd')
  end
end

context 'debian' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(
      platform: 'debian',
      version: '7.5'
    ).converge(described_recipe)
  end

  it 'installs samba' do
    expect(chef_run).to install_package 'samba'
  end

  it 'manages smb.conf' do
    expect(chef_run).to create_template('/etc/samba/smb.conf')
  end

  it 'notifies samba services to restart when updating the config' do
    resource = chef_run.template('/etc/samba/smb.conf')
    expect(resource).to notify('service[samba]').to(:restart)
  end

  it 'manages the samba service(s)' do
    expect(chef_run).to enable_service('samba')
    expect(chef_run).to start_service('samba')
  end
end
