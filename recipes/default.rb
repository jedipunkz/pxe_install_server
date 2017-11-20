# Cookbook Name:: pxe_install_server
# Author:: Tomokazu Hirai ( @jedipunkz )
#
# Recipe:: default
#

execute "apt-get-update-periodic" do
  command "apt-get update"
  ignore_failure true
  only_if do
    File.exists?('/var/lib/apt/periodic/update-success-stamp') &&
    File.mtime('/var/lib/apt/periodic/update-success-stamp') < Time.now - 86400
  end
end

include_recipe 'pxe_install_server::dhcpd'
include_recipe 'pxe_install_server::tftpd'
