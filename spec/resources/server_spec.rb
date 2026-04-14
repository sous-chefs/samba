# frozen_string_literal: true

require 'spec_helper'

describe 'samba_server' do
  step_into :samba_server
  platform 'ubuntu', '22.04'

  context 'create action' do
    recipe do
      samba_server 'test-server' do
        workgroup 'TESTGROUP'
        interfaces 'eth0'
        hosts_allow '10.0.0.0/8'
      end
    end

    it { is_expected.to install_package('samba') }
    it { is_expected.to create_template('/etc/samba/smb.conf') }
  end

  context 'when shares are declared separately' do
    recipe do
      samba_server 'test-server'

      samba_share 'homes' do
        comment 'Home Directories'
        guest_ok 'no'
        read_only 'no'
        browseable 'no'
        create_directory false
      end
    end

    it 'renders the share into smb.conf' do
      expect(chef_run).to render_file('/etc/samba/smb.conf').with_content('[homes]')
      expect(chef_run).to render_file('/etc/samba/smb.conf').with_content('comment = Home Directories')
      expect(chef_run).to render_file('/etc/samba/smb.conf').with_content('browseable = no')
    end
  end
end
