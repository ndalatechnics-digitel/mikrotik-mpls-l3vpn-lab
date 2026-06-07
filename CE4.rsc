# 2026-06-07 08:31:45 by RouterOS 7.21.4
# system id = Ul7euwgisMM
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
/routing bgp instance
add as=65520 disabled=no name=EBGP router-id=10.254.0.4 routing-table=main \
    vrf=main
/ip address
add address=10.254.0.4 interface=Loopback network=10.254.0.4
add address=10.0.17.2/30 interface=ether1 network=10.0.17.0
add address=192.168.204.1/24 interface=ether2 network=192.168.204.0
/ip dhcp-client
add interface=ether1
/ip firewall address-list
add address=192.168.204.0/24 list=BGP-OUT
/routing bgp connection
add afi=ip as=65520 connect=yes disabled=no instance=EBGP listen=yes \
    local.address=10.0.17.2 .role=ebgp name=EBGP-PE2 output.network=BGP-OUT \
    remote.address=10.0.17.1/32 .as=65500 routing-table=main vrf=main
/system identity
set name=CE4
/tool romon
set enabled=yes
