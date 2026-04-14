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
end
