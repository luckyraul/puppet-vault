# frozen_string_literal: true

require 'json'
require 'puppet/resource_api/simple_provider'
require 'puppet_x/vaultpki/client'

# Implementation for the vault_cert type using the Resource API.
class Puppet::Provider::VaultCert::VaultCert < Puppet::ResourceApi::SimpleProvider
  def get(context)
    context.debug('Returning pre-canned example data')
    [
      {
        name: 'foo',
        ensure: 'present',
      },
      {
        name: 'bar',
        ensure: 'present',
      },
    ]
  end

  def create(context, name, should)
    context.notice("Creating '#{name}' with #{should.inspect}")
    context.notice(client.hello)
    client.create_cert(
      common_name: resource[:common_name],
      ttl: resource[:cert_ttl],
      alt_names: resource[:alt_names],
      ip_sans: resource[:ip_sans],
    )
  end

  def update(context, name, should)
    context.notice("Updating '#{name}' with #{should.inspect}")
  end

  def delete(context, name)
    context.notice("Deleting '#{name}'")
  end

  def client
    @client ||= PuppetX::Vaultpki::Client.new
    @client
  end
end
