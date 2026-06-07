# 2026-06-07 08:09:54 by RouterOS 7.21.4
# system id = ZgQ29+RkD0G
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
add interfaces=ether2,ether3 name=BANK
/routing bgp instance
add as=65500 comment=EBGP_INSTANCE disabled=no name=EBGP router-id=10.255.0.3 \
    routing-table=BANK vrf=BANK
/routing id
add disabled=no id=10.255.0.3 name=RID select-dynamic-id=""
/routing bgp instance
add as=65500 disabled=no name=IBGP router-id=RID routing-table=main vrf=main
/routing isis instance
add areas=49.0001 name=DNS system-id=0000.0AFF.0003
/ip address
add address=10.255.0.3 interface=Loopback network=10.255.0.3
add address=10.0.9.2/30 interface=ether1 network=10.0.9.0
add address=10.0.11.1/30 interface=ether2 network=10.0.11.0
add address=10.0.19.1/30 interface=ether3 network=10.0.19.0
add address=10.0.10.2/30 interface=ether4 network=10.0.10.0
/ip dhcp-client
add interface=ether1
/mpls interface
add disabled=no interface=ether1
add disabled=no interface=ether4
/mpls ldp
add disabled=no lsr-id=10.255.0.3 transport-addresses=10.255.0.3
/mpls ldp interface
add disabled=no interface=ether1 transport-addresses=10.255.0.3
add disabled=no interface=ether4 transport-addresses=10.255.0.3
/routing bgp connection
add afi=ip,vpnv4 as=65500 comment=IBGP_TO_RR connect=yes disabled=no \
    instance=IBGP listen=yes local.address=10.255.0.3 .role=ibgp name=iBGP-RR \
    remote.address=10.255.0.5/32 .as=65500 routing-table=main vrf=main
add afi=ip as=65500 comment=IBGP_TO_CE2 connect=yes disabled=no instance=EBGP \
    listen=yes local.address=10.0.19.1 .role=ebgp name=EBGP-CE2 \
    output.as-override=yes .default-originate=if-installed .redistribute=\
    bgp,bgp-mpls-vpn remote.address=10.0.19.2/32 .as=65520 routing-table=BANK \
    vrf=BANK
add afi=ip as=65500 comment=IBGP_TO_CE3 connect=yes disabled=no instance=EBGP \
    listen=yes local.address=10.0.11.1 .role=ebgp name=EBGP-CE3 \
    output.as-override=yes .default-originate=if-installed .redistribute=\
    bgp,bgp-mpls-vpn remote.address=10.0.11.2/32 .as=65520 routing-table=BANK \
    vrf=BANK
/routing bgp vpn
add disabled=no export.redistribute=bgp .route-targets=65500:1 \
    import.route-targets=65500:1 instance=EBGP label-allocation-policy=\
    per-vrf name=bgp-mpls-vpn-1 route-distinguisher=65500:3 vrf=BANK
/routing isis interface-template
add instance=DNS interfaces=ether1,ether4 levels=l2 ptp
add instance=DNS interfaces=Loopback levels=l2 passive
/system identity
set name=PE3
/tool romon
set enabled=yes
