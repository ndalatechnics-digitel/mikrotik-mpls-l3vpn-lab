# 2026-06-07 08:09:26 by RouterOS 7.21.4
# system id = f80JGbJn5BD
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
add interfaces=ether2,ether4,ether5 name=BANK
/routing bgp instance
add as=65500 name=IBGP router-id=10.255.0.2 routing-table=main vrf=main
add as=65500 comment=EBGP_TO_CLIENTS disabled=no name=EBGP router-id=\
    10.255.0.1 routing-table=BANK vrf=BANK
/routing id
add disabled=no id=10.255.0.2 name=RID select-dynamic-id=""
/routing isis instance
add areas=49.0001 name=DNS system-id=0000.0AFF.0002
/ip address
add address=10.255.0.2 interface=Loopback network=10.255.0.2
add address=10.0.23.2/30 interface=ether1 network=10.0.23.0
add address=10.0.17.1/30 interface=ether2 network=10.0.17.0
add address=10.0.13.2/30 interface=ether3 network=10.0.13.0
add address=10.0.25.2/30 interface=ether4 network=10.0.25.0
add address=10.0.16.1/30 interface=ether5 network=10.0.16.0
/ip dhcp-client
add interface=ether1
/mpls interface
add disabled=no interface=ether1
add disabled=no interface=ether3
/mpls ldp
add disabled=no lsr-id=10.255.0.2 transport-addresses=10.255.0.2
/mpls ldp interface
add disabled=no interface=ether1 transport-addresses=10.255.0.2
add disabled=no interface=ether3 transport-addresses=10.255.0.2
/routing bgp connection
add afi=ip,vpnv4 as=65500 comment=IBGP_TO_RR connect=yes disabled=no \
    instance=IBGP listen=yes local.address=10.255.0.2 .role=ibgp name=IBGP-RR \
    remote.address=10.255.0.5 .as=65500 routing-table=main vrf=main
add afi=ip as=65500 comment=EBGP_CE4 connect=yes disabled=no instance=EBGP \
    listen=yes local.address=10.0.17.1 .role=ebgp name=EBGP_CE4 \
    output.as-override=yes .default-originate=if-installed .redistribute=\
    bgp,bgp-mpls-vpn remote.address=10.0.17.2/32 .as=65520 routing-table=BANK \
    vrf=BANK
add afi=ip as=65500 comment=EBGP_CE5 connect=yes disabled=no instance=EBGP \
    listen=yes local.address=10.0.16.1 .role=ebgp name=EBGP_CE5 \
    output.as-override=yes .default-originate=if-installed .redistribute=\
    bgp,bgp-mpls-vpn remote.address=10.0.16.2/32 .as=65520 routing-table=BANK \
    vrf=BANK
add afi=ip as=65500 comment=EBGP_CE4 connect=yes disabled=no instance=EBGP \
    listen=yes local.address=10.0.25.2 .role=ebgp name=EBGP-HQ \
    output.as-override=yes .default-originate=if-installed .redistribute=\
    bgp,bgp-mpls-vpn remote.address=10.0.25.1/32 .as=65520 routing-table=BANK \
    vrf=BANK
/routing bgp vpn
add disabled=no export.redistribute=bgp .route-targets=65500:1 \
    import.route-targets=65500:1 instance=EBGP label-allocation-policy=\
    per-vrf name=bgp-mpls-vpn-1 route-distinguisher=65500:2 vrf=BANK
/routing isis interface-template
add instance=DNS interfaces=ether1,ether3 levels=l2 ptp
add instance=DNS interfaces=Loopback levels=l2 passive
/system identity
set name=PE2
/tool romon
set enabled=yes
