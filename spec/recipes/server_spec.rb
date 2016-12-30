require_relative '../spec_helper'

describe 'samba::server' do
  before(:each) do
    samba_shares = {
      'id' => 'shares',
      'shares' => {
        'export' => {
          'comment' => 'Exported Share',
          'path' => '/srv/export',
          'guest ok' => 'no',
          'printable' => 'no',
          'write list' => ['smbuser'],
          'create mask' => '0664',
          'directory mask' => '0775',
        },
      },
    }
    samba_users = [{
      'id' => 'jtimberman',
      'smbpasswd' => 'plaintextpassword',
    }]
    samba_admins = [{
      'id' => 'tscott',
      'smbpasswd' => 'zomgsosecure',
    }]

    stub_data_bag_item('samba', 'shares').and_return(samba_shares)
    stub_search('users', '*:*').and_return(samba_users)
    stub_search('admins', '*:*').and_return(samba_admins)

    allow(Mixlib::ShellOut).to receive(:new).and_return(double('shellout', :live_stream= => nil, :run_command => nil, :stdout => ''))
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

  context 'centos' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(
        platform: 'centos',
        version: '6.5'
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
      expect(resource).to notify('service[smb]').to(:restart)
      expect(resource).to notify('service[nmb]').to(:restart)
    end

    it 'manages the samba service(s)' do
      expect(chef_run).to enable_service('smb')
      expect(chef_run).to enable_service('nmb')
      expect(chef_run).to start_service('smb')
      expect(chef_run).to start_service('nmb')
    end
  end

  context 'automatic user installation' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(
        platform: 'ubuntu',
        version: '14.04',
        step_into: ['samba_user']
      )
    end

    it 'sets up samba users from a data_bag search when enabled' do
      chef_run.node.set['samba']['enable_users_search'] = true
      chef_run.converge(described_recipe)
      expect(chef_run).to create_samba_user('jtimberman')
    end

    it 'does not automatically set up samba users when disabled' do
      chef_run.node.set['samba']['enable_users_search'] = false
      chef_run.converge(described_recipe)
      expect(chef_run).to_not create_samba_user('jtimberman')
    end

    it 'searches alternative data_bag for samba users when provided' do
      chef_run.node.set['samba']['enable_users_search'] = true
      chef_run.node.set['samba']['users_data_bag'] = 'admins'
      chef_run.converge(described_recipe)
      expect(chef_run).to create_samba_user('tscott')
    end
  end
end
