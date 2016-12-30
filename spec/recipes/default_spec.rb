require 'spec_helper'

describe 'samba::default' do
  let(:chef_run) { ChefSpec::SoloRunner.new.converge(described_recipe) }

  it 'includes the client recipe' do
    expect(chef_run).to include_recipe 'samba::client'
  end
end
