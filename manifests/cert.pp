# @summary A short summary of the purpose of this defined type.
#
# A description of what this defined type does
#
# @param ensure Require pip to be available.
#
# @example
#   vaultpki::cert { 'namevar': }
define vaultpki::cert (
  String $ensure
) {
  vault_cert { $title:
    ensure => $ensure,
  }
}
