# 2026-06-07 08:13:28 by RouterOS 7.21.4
# system id = 0npdRQmJ4gE
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
add as=65500 comment=iBGP_Instance name=IBGP router-id=10.255.0.5 \
    routing-table=main vrf=main
/routing id
add disabled=no id=10.255.0.5 name=RID select-dynamic-id=""
/routing isis instance
add areas=49.0001 name=DNS system-id=0000.0AFF.0015
/ip address
add address=10.255.0.5 interface=Loopback network=10.255.0.5
add address=10.0.21.2/30 interface=ether1 network=10.0.21.0
add address=10.0.22.2/30 interface=ether2 network=10.0.22.0
/ip dhcp-client
add interface=ether1
# Interface not active
add interface=ether3
/mpls interface
add disabled=no interface=ether1
add disabled=no interface=ether2
/mpls ldp
add disabled=no lsr-id=10.255.0.5 transport-addresses=10.255.0.5
/mpls ldp interface
add disabled=no interface=ether1 transport-addresses=10.255.0.5
add disabled=no interface=ether2 transport-addresses=10.255.0.5
/routing bgp connection
add afi=ip,vpnv4 as=65500 comment=TO-PE1 connect=yes instance=IBGP listen=yes \
    local.address=10.255.0.5 .role=ibgp-rr name=IBGP-PE1 remote.address=\
    10.255.0.1 .as=65500
add afi=ip,vpnv4 as=65500 comment=TO-PE2 connect=yes disabled=no instance=\
    IBGP listen=yes local.address=10.255.0.5 .role=ibgp-rr name=IBGP-PE2 \
    remote.address=10.255.0.2 .as=65500 routing-table=main vrf=main
add afi=ip,vpnv4 as=65500 comment=TO-PE3 connect=yes disabled=no instance=\
    IBGP listen=yes local.address=10.255.0.5 .role=ibgp-rr name=IBGP-PE3 \
    remote.address=10.255.0.3 .as=65500 routing-table=main vrf=main
add afi=ip,vpnv4 as=65500 comment=TO-PE4 connect=yes instance=IBGP listen=yes \
    local.address=10.255.0.5 .role=ibgp-rr name=IBGP-PE4 remote.address=\
    10.255.0.4 .as=65500
/routing isis interface-template
add instance=DNS interfaces=ether1,ether2 levels=l2 ptp
add instance=DNS interfaces=Loopback levels=l2 passive
/system identity
set name=RR
/tool romon
set enabled=yes
