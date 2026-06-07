# 2026-06-07 08:08:35 by RouterOS 7.21.4
# system id = GcI2VtRIGzB
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
/ip vrf
add interfaces=ether2,ether3,ether5,ether6 name=BANK
/routing bgp instance
add as=65500 comment=iBGP_Instance disabled=no name=IBGP router-id=10.255.0.1 \
    routing-table=main vrf=main
add as=65500 disabled=no name=EBGP router-id=10.255.0.1 routing-table=BANK \
    vrf=BANK
/routing id
add disabled=no id=10.255.0.1 name=RID select-dynamic-id=""
/routing isis instance
add areas=49.0001 name=DNS system-id=0000.0AFF.0001
/ip address
add address=10.255.0.1 interface=Loopback network=10.255.0.1
add address=10.0.7.2/30 interface=ether1 network=10.0.7.0
add address=10.0.5.1/30 interface=ether2 network=10.0.5.0
add address=10.0.12.1/30 interface=ether3 network=10.0.12.0
add address=10.0.8.2/30 interface=ether4 network=10.0.8.0
add address=10.0.20.2/30 interface=ether5 network=10.0.20.0
/ip dhcp-client
add add-default-route=no interface=ether6
/ip firewall nat
add action=masquerade chain=srcnat out-interface=ether6
/ip route
add disabled=no distance=1 dst-address=0.0.0.0/0 gateway=192.168.118.2@BANK \
    routing-table=BANK scope=30 target-scope=10
/mpls interface
add disabled=no interface=ether1
add disabled=no interface=ether4
/mpls ldp
add disabled=no lsr-id=10.255.0.1 transport-addresses=10.255.0.1
/mpls ldp interface
add disabled=no interface=ether1 transport-addresses=10.255.0.1
add disabled=no interface=ether4 transport-addresses=10.255.0.1
/routing bgp connection
add afi=ip,vpnv4 as=65500 connect=yes disabled=no instance=IBGP listen=yes \
    local.address=10.255.0.1 .role=ibgp name=iBGP-RR output.redistribute="" \
    remote.address=10.255.0.5/32 .as=65500 routing-table=main vrf=main
add afi=ip as=65500 connect=yes disabled=no instance=EBGP listen=yes \
    local.address=10.0.12.1 .role=ebgp name=EBGP-CE1 output.as-override=yes \
    .default-originate=if-installed .redistribute=bgp,bgp-mpls-vpn \
    remote.address=10.0.12.2/32 .as=65520 routing-table=BANK vrf=BANK
add afi=ip as=65500 connect=yes disabled=no instance=EBGP listen=yes \
    local.address=10.0.5.1 .role=ebgp name=EBGP-CE2 output.as-override=yes \
    .default-originate=if-installed .redistribute=bgp,bgp-mpls-vpn \
    remote.address=10.0.5.2/32 .as=65520 routing-table=BANK vrf=BANK
add afi=ip as=65500 connect=yes disabled=no instance=EBGP listen=yes \
    local.address=10.0.20.2 .role=ebgp name=EBGP-HQ output.as-override=yes \
    .default-originate=if-installed .redistribute=bgp,bgp-mpls-vpn \
    remote.address=10.0.20.1/32 .as=65520 routing-table=BANK vrf=BANK
/routing bgp vpn
add disabled=no export.redistribute=static,bgp .route-targets=65500:1 \
    import.route-targets=65500:1 instance=EBGP label-allocation-policy=\
    per-vrf name=bgp-mpls-vpn-1 route-distinguisher=65500:1 vrf=BANK
/routing isis interface-template
add comment=TO-P1/P3 instance=DNS interfaces=ether1,ether4 levels=l2 ptp
add instance=DNS interfaces=Loopback levels=l2 passive
/system identity
set name=PE1
/tool romon
set enabled=yes
