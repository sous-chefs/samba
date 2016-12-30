require_relative '../spec_helper'

describe 'samba::client' do
  context 'ubuntu' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(
        platform: 'ubuntu',
        version: '14.04'
      ).converge(described_recipe)
    end

    it 'installs samba' do
      expect(chef_run).to install_package 'smbclient'
    end
  end

  context 'debian' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(
        platform: 'debian',
        version: '7.11'
      ).converge(described_recipe)
    end

    it 'installs samba' do
      expect(chef_run).to install_package 'smbclient'
    end
  end

  context 'centos' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(
        platform: 'centos',
        version: '6.8'
      ).converge(described_recipe)
    end

    it 'installs samba' do
      expect(chef_run).to install_package 'samba-client'
    end
  end
end
