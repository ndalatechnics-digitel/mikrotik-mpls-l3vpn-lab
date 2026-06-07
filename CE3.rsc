# 2026-06-07 08:31:25 by RouterOS 7.21.4
# system id = OShCHARTjCK
#
/interface bridge
add name=Loopback
/interface ethernet
set [ find default-name=ether1 ] disable-running-check=no
set [ find default-name=ether2 ] disable-running-check=no
set [ find default-name=ether3 ] disable-running-check=no
set [ find default-name=ether4 ] disable-running-check=no
set [ find default-name=ether5 ] disable-running-check=no
set [ find default-name=ether6 ] disable-running-check=no
set [ find default-name=ether7 ] disable-running-check=no
set [ find default-name=ether8 ] disable-running-check=no
/ip pool
add name=dhcp_pool0 ranges=192.168.203.2-192.168.203.254
/ip dhcp-server
add address-pool=dhcp_pool0 interface=ether2 name=dhcp1
/routing bgp instance
add as=65520 disabled=no name=EBGP router-id=10.255.0.3 routing-table=main \
    vrf=main
/ip address
add address=10.254.0.3 interface=Loopback network=10.254.0.3
add address=10.0.11.2/30 interface=ether1 network=10.0.11.0
add address=192.168.203.1/24 interface=ether2 network=192.168.203.0
/ip dhcp-client
add interface=ether1
/ip dhcp-server network
add address=192.168.203.0/24 dns-server=8.8.8.8 gateway=192.168.203.1
/ip firewall address-list
add address=192.168.203.0/24 list=BGP-OUT
/routing bgp connection
add afi=ip connect=yes disabled=no instance=EBGP listen=yes local.address=\
    10.0.11.2 .role=ebgp name=EBGP-PE3 output.network=BGP-OUT remote.address=\
    10.0.11.1/32 .as=65500
/system identity
set name=CE3
/tool romon
set enabled=yes
