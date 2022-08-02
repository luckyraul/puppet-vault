# @summary A short summary of the purpose of this defined type.
#
# A description of what this defined type does
#
# @param ensure Specifies whether the cert should exist. Valid options: 'present', and 'absent'
#
# @example
#   vaultpki::cert { 'namevar': }
define vaultpki::cert (
  Enum['present', 'absent'] $ensure = present
) {
  vault_cert { $title:
    ensure => $ensure,
  }
}
