# Cookbook Name:: pxe_install_server
# Author:: Tomokazu Hirai ( @jedipunkz )
#
# Recipe:: tftpd
#

package "tftpd-hpa"

node['pxe_install_server']['releases'].each do |release|
  dist = release[:dist]
  path = release[:path]
  remote_file "#{Chef::Config[:file_cache_path]}/#{dist}.amd64.netboot.tar.gz" do
    source path
    not_if { File.exists?("#{node["pxe_install_server"]["tftp_dir"]}/#{dist}") || File.exists?("/tmp/#{dist}.amd64.netboot.tar.gz") }
  end

  script "copy netboot files" do
    interpreter "bash"
    user "root"
    code <<-EOH
    mkdir -p #{node["pxe_install_server"]["tftp_dir"]}/#{dist}
    tar zxvf /#{Chef::Config[:file_cache_path]}/#{dist}.amd64.netboot.tar.gz -C #{node["pxe_install_server"]["tftp_dir"]}/#{dist}
    EOH
  end
end

targets = data_bag_item('development', node["pxe_install_server"]["data_bag_name"])['targets']

targets.each do |target|
  mac = target['mac'].downcase.gsub(/:/, '-')
  template "#{node["pxe_install_server"]["tftp_dir"]}/#{target['release']}/pxelinux.cfg/01-#{mac}" do
    source "pxelinux.#{target['release']}.erb"
    mode 0644
    variables({
      :mac => mac,
      :release => target['release']
    })
    notifies(:restart, "service[tftpd-hpa]")
  end

  template "#{node["pxe_install_server"]["tftp_dir"]}/#{target['release']}/preseed.ubuntu.cfg" do
    source "preseed.ubuntu.cfg.erb"
    mode 0644
    variables({
      :fullname => target['user-fullname'],
      :username => target['username'],
      :passwd   => target['user-password-crypted'],
      :release => target['release']
    })
    only_if { target["release"].include?("ubuntu") }
  end

  template "#{node["pxe_install_server"]["tftp_dir"]}/#{target['release']}/preseed.debian.cfg" do
    source "preseed.debian.cfg.erb"
    mode 0644
    variables({
      :fullname => target['user-fullname'],
      :username => target['username'],
      :passwd   => target['user-password-crypted'],
      :release => target['release']
    })
    only_if { target["release"].include?("debian") }
  end
end

service "tftpd-hpa" do
  restart_command "service tftpd-hpa restart"
  start_command "service tftpd-hpa start"
  supports :restart => true
  action :restart
end
