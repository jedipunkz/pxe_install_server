Coobook for building PXE Installation Environment
==================

Overview
----

Opscode Chef Cookbook for building PXE installation environment that includes these services.

* TFTP server
* DHCP server
* Preseed config for debian and ubuntu linux

Boot machines you want to build with PXE network boot. Machine will be built automaticaly.
Now I support Debian Gnu/Linux and Ubuntu with your target machine. Please fork it and add target OSs.


Supporting Server OS
----

* Debian Gnu/Linux 7.1
* Ubuntu Server 16.04 LTS

Supporting Target OS
----

* Debian Gnu/Linux 9.2
* Ubuntu Server 16.04 LTS

And maybe, you can add any distro to attribute file. Please fork it and fun. :D

Authror
----

* name : Tomokazu HIRAI ( @jedipunkz )
* blog : http://jedipunkz.github.io/
* twitter : https://twitter.com/jedipunkz

Attributes
----

| Key | Type | Description | Default |
|-----|------|-------------|---------|
| ['pxe_install_server']['pxeserver_service_host'] | String | PXE Server Address | 10.0.11.202 |
| ['pxe_install_server']['pxeserver_address'] | String | PXE Server Network Address | 10.0.11.0 |
| ['pxe_install_server']['pxeserver_netmask'] | String | PXE Server Netmask | 255.255.255.0 |
| ['pxe_install_server']['pxeserver_broadcast'] | String | PXE Server Broadcast Address | 10.0.11.255|
| ['pxe_install_server']['pxeserver_range_min'] | String | PXE DHCP Range (min) | 10.0.11.10 |
| ['pxe_install_server']['pxeserver_range_max'] | String | PXE DHCP Range(max)| 10.0.11.15 |
| ['pxe_install_server']['pxeserver_router'] | String | PXE DHCP Default GW | 10.0.11.200 |
| ['pxe_install_server']['pxeserver_nameserver'] | String | PXE DHCP Nameserver | 8.8.8.8 |
| ['pxe_install_server']['tftp_dir'] | String | TFTP Directory | /srv/tftp, /var/lib |
| ['pxe_install_server']['data_bag_name'] | String | data bag of target information | development |


How to use
----

git clone this repository

```bash
% cd ~/your_chef_repo
% git clone git://github.com/jedipunkz/pxe_instal_server.git ./cookbooks/pxe_install_server
```

Upload this cookbook to your chef server.

```bash
% knife cookbook upload -o ./cookbook pxe_install_server
```

create data bag.

```bash
% knife data bag create pxe_targets
```

edit data bag which named 'pxe_targets' and includes target nodes information.

```json
% ${EDITOR} data_bags/pxe_targets/development.json
{
  "id": "development",
  "targets": [
    {
      "ip": "10.200.9.203",
      "mac": "00:50:56:01:01:04",
      "release": "ubuntu-14.04-amd64",
      "hostname": "test01",
      "user-fullname": "Test User",
      "username": "testuser",
      "user-password-crypted": "$1$tCt.rk5c$t4T.Nrk4TZ15hpxrsZotV0"          
    },
    {
      "ip": "10.200.9.201",
      "mac": "00:50:56:01:01:03",
      "release": "debian-9.2-amd64",
      "hostname": "test02",
      "user-fullname": "Test User",
      "username": "testuser",
      "user-password-crypted": "$1$tCt.rk5c$t4T.Nrk4TZ15hpxrsZotV0"
    }
  ]
}
```

upload data bag to chef server.

```bash
% knife data bag from file pxe_targets data_bags/pxe_targets/development.json
```

Bootstrap your node which you want to build for PXE install server with this
cookbook.

```bash
% knife bootstrap <ip_addr> -N <node_name> -r 'recipe[pxe_install_server]' \
      --sudo -x <your_account_name>
```

Version
----

* 0.0.6 : added supporting debian 9.2 and deleted debian 7.2
* 0.0.5 : added suporting ubuntu 16.04 for target os.
* 0.0.4 : supported ubuntu 14.04 for target os.
* 0.0.3 : supported to specify user account for preseed.
* 0.0.2 : blush up vesion
* 0.0.1 : first version :D

Known Bugs
----

None
