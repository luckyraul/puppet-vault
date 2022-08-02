# frozen_string_literal: true

require 'spec_helper'
require 'puppet/type/vault_cert'

RSpec.describe 'the vault_cert type' do
  it 'loads' do
    expect(Puppet::Type.type(:vault_cert)).not_to be_nil
  end
end
