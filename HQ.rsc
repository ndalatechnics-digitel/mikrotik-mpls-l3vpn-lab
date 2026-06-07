# 2026-06-07 08:33:26 by RouterOS 7.21.4
# system id = wZAcXfkMjXK
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
add name=dhcp_pool0 ranges=192.168.207.2-192.168.207.254
/ip dhcp-server
add address-pool=dhcp_pool0 interface=ether4 name=dhcp1
/routing bgp instance
add as=65514 disabled=no name=eBGP-PE1 router-id=10.254.0.7 routing-table=\
    main vrf=main
/ip address
add address=10.0.20.1/30 interface=ether2 network=10.0.20.0
add address=10.0.25.1/30 interface=ether3 network=10.0.25.0
add address=10.254.0.7 interface=Loopback network=10.254.0.7
add address=192.168.207.1/24 interface=ether4 network=192.168.207.0
/ip dhcp-client
# Interface not active
add interface=ether1
/ip dhcp-server network
add address=192.168.207.0/24 dns-server=8.8.8.8 gateway=192.168.207.1
/ip firewall address-list
add address=192.168.207.0/24 list=BGP-OUT
/routing bgp connection
add afi=ip as=65520 comment=TO-PE1 connect=yes disabled=no instance=eBGP-PE1 \
    listen=yes local.address=10.0.20.1 .role=ebgp name=TO-PE1 output.network=\
    BGP-OUT remote.address=10.0.20.2/32 .as=65500 routing-table=main vrf=main
add afi=ip as=65520 comment=TO-PE2 connect=yes disabled=no instance=eBGP-PE1 \
    listen=yes local.address=10.0.25.1 .role=ebgp name=TO-PE2 output.network=\
    BGP-OUT remote.address=10.0.25.2/32 .as=65500 routing-table=main vrf=main
/system identity
set name=HQ
/tool romon
set enabled=yes
