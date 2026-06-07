# 2026-06-07 08:30:45 by RouterOS 7.21.4
# system id = WgGj7Qma0nP
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
add name=dhcp_pool0 ranges=192.168.201.2-192.168.201.254
/routing bgp instance
add as=65520 disabled=no name=EBGP router-id=10.254.0.1 routing-table=main \
    vrf=main
/routing id
add disabled=no id=10.254.0.1 name=RID select-dynamic-id=""
/ip address
add address=10.254.0.1 interface=Loopback network=10.254.0.1
add address=10.0.12.2/30 interface=ether1 network=10.0.12.0
add address=192.168.201.1/24 interface=ether2 network=192.168.201.0
/ip dhcp-client
add interface=ether1
/ip dhcp-server
add address-pool=dhcp_pool0 interface=ether2 name=dhcp1
/ip dhcp-server network
add address=192.168.201.0/24 dns-server=8.8.8.8 gateway=192.168.201.1
/ip firewall address-list
add address=192.168.201.0/24 list=OUT-BGP
/routing bgp connection
add as=65520 connect=yes disabled=no instance=EBGP listen=yes local.address=\
    10.0.12.2 .role=ebgp name=bgp1 output.network=OUT-BGP remote.address=\
    10.0.12.1/32 .as=65500 routing-table=main vrf=main
/routing filter rule
add chain=OUT-BGP rule="if (dst in 192.168.201.0/24) { accept }"
/system identity
set name=CE1
/tool romon
set enabled=yes
