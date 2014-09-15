require_relative 'spec_helper'

describe command('smbclient --help') do
  it { should return_exit_status(0) }
end
