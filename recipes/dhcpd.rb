# Cookbook Name:: pxe_install_server
# Author:: Tomokazu Hirai ( @jedipunkz )
#
# Recipe:: dhcpd
#

package "isc-dhcp-server"

targets = data_bag_item('development', node["pxe_install_server"]["data_bag_name"])['targets']

template "/etc/dhcp/dhcpd.conf" do
  source "dhcpd.conf.erb"
  owner "root"
  group "root"
  mode 0644
  variables :targets => targets
  notifies(:restart, "service[isc-dhcp-server]")
end

service "isc-dhcp-server" do
  restart_command "service isc-dhcp-server restart"
  start_command "service isc-dhcp-server start"
  supports :restart => true
  action :restart
end
