# 2026-06-07 08:30:23 by RouterOS 7.21.4
# system id = mO8c6Yr/CWP
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
/routing isis instance
add areas=49.0001 name=DNS system-id=0000.0AFF.0014
/ip address
add address=10.255.0.14 interface=Loopback network=10.255.0.14
add address=10.0.2.2/30 interface=ether1 network=10.0.2.0
add address=10.0.3.2/30 interface=ether2 network=10.0.3.0
add address=10.0.5.2/30 interface=ether3 network=10.0.5.0
add address=10.0.24.1/30 interface=ether4 network=10.0.24.0
add address=10.0.13.1/30 interface=ether5 network=10.0.13.0
add address=10.0.22.1/30 interface=ether6 network=10.0.22.0
/ip dhcp-client
add interface=ether1
/mpls interface
add disabled=no interface=ether1
add disabled=no interface=ether2
add disabled=no interface=ether3
add disabled=no interface=ether4
add disabled=no interface=ether5
add disabled=no interface=ether6
/mpls ldp
add disabled=no lsr-id=10.255.0.14 transport-addresses=10.255.0.14
/mpls ldp interface
add disabled=no interface=ether1 transport-addresses=10.255.0.14
add disabled=no interface=ether2 transport-addresses=10.255.0.14
add disabled=no interface=ether3 transport-addresses=10.255.0.14
add disabled=no interface=ether4 transport-addresses=10.255.0.14
add disabled=no interface=ether5 transport-addresses=10.255.0.14
add disabled=no interface=ether6 transport-addresses=10.255.0.14
/routing isis interface-template
add instance=DNS interfaces=ether1,ether2,ether3,ether4,ether5,ether6 levels=\
    l2 ptp
add instance=DNS interfaces=Loopback levels=l2 passive
/system identity
set name=P4
/tool romon
set enabled=yes
