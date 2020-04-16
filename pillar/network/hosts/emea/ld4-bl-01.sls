proxy:
  host: ld4-bl-01.net.arkadin.lan
  driver: junos

dc: ld4
region: emea
type: network

# WORKAROUND PROBLEM REPORT http://prsearch.juniper.net/PR1398398
processes:
  disable:
    - na-grpc-server
    - jsd

# ASN ASSIGNEMENT https://netwiki.net.arkadin.lan/resources/asn
fabric_asn: 64301

# INTERFACES CONFIGURATION https://netwiki.net.arkadin.lan/resources/ipfabricaddr
interfaces:

# PHYSICAL https://netwiki.net.arkadin.lan/standards/mx204ports
# physical > name, description, state: enable/disable, lacp for aggregated interface, mtu
  - { name: et-0/0/0, descr: 'X:ld4-sp-01:et-0/0/0:spine', state: disable, lacp: ae1 }
  - { name: et-0/0/1, descr: 'X:ld4-sp-02:et-0/0/0:spine', state: disable, lacp: ae2 }
  - { name: et-0/0/3, descr: 'X:ld4-bl-02:et-0/0/3:b2b', state: enable, lacp: ae0 }
  - { name: xe-0/1/0, descr: 'Q:ld4-ce-01:xe-0/0/46:ce', state: disable, lacp: ae11 }
  - { name: xe-0/1/1, descr: 'Q:ld4-ce-02:xe-0/0/46:ce', state: disable, lacp: ae12 }

# AGGREGATE LACP https://netwiki.net.arkadin.lan/standards/ae
# subinterface or ae > unit vlan ID, description, state: enable/disable, mpls: true/false
  - { name: ae0, descr: 'X:ld4-bl-01:ae0.0:b2b', mtu: 9234, unit: {id: 0, address: 172.22.12.0/31, mpls: true} }
  - { name: ae1, descr: 'X:ld4-sp-01:ae31.0:spine', unit: {id: 0, address: 172.22.12.2/31} }
  - { name: ae2, descr: 'X:ld4-sp-02:ae31.0:spine', unit: {id: 0, address: 172.22.12.4/31} }
  - { name: ae11, descr: 'Q:ld4-ce-01:ae1.10:ce', mtu: 1600, unit: {id: 10, address: 172.22.12.32/31, mpls: true} }
  - { name: ae12, descr: 'Q:ld4-ce-02:ae1.10:ce', mtu: 1600, unit: {id: 10, address: 172.22.12.34/31, mpls: true} }

# OOB FXP0
  - { name: fxp0, descr: 'M:10.101.14.0/24:mgmt', unit: {id: 0, address: 10.101.14.55/24} }

# LOOPBACK https://netwiki.net.arkadin.lan/resources/ipfabricaddr#loopbacks
  - { name: lo0, descr: 'L:172.16.0.27/32:legacy', unit: {id: 0, address: 172.16.0.27/32} }
  - { name: lo0, descr: 'L:192.168.3.1/32:border', unit: {id: 1, address: 192.168.3.1/32} }
  - { name: lo0, descr: 'L:185.37.223.34/32:inet', unit: {id: 2, address: 185.37.223.34/32} }

# IXRT LEGACY 1G or 10G
  - { name: xe-0/1/2, descr: 'Q:ld4ixag01:Gi1/0/9:ixag', state: enable, mtu: 9198, speed1g: true,
  unit: {id: 1999, descr: 'X:ld4ixrt01:Gi0/0/1.1999', mtu: 9170, address: 172.22.14.0/31, mpls: true}}

# UPLINKS BACKBONE 1G or 10G 172.30.251.0/24 https://device42.arkadin.lan/admin/rackraj/vlan/530/
# 1580 bytes (1500 ethernet payload + 14 Ethernet + 50 VXLAN (8+8+14+20) + 12 MPLS + 4 VLAN).
# 1562 bytes 18 bytes = 6(DMAC)+6(SMAC)+2(EtherType))+4(VLAN).
  - { name: xe-0/1/4, descr: 'E:COLT_PAR/LON/LE-517463:SID-EU-01611473:pa2-bl-01:backbone', state: enable, mtu: 1580,
  unit: {id: 0, descr: 'X:pa2-bl-01:xe-0/1/4.0', address: 172.30.251.18/30, mpls: true}}
  - { name: xe-0/1/5, descr: 'E:ZAYO_LD4/ATL/ETYX/236871//ZYO:SID-EU-01611487:at1-bl-02:backbone', state: enable, mtu: 1580, speed1g: true,
  unit: {id: 500, descr: 'X:at1-bl-02:xe-0/1/4.500', address: 172.30.251.33/30, mpls: true}}

# RPM PROBES
rpm:
  - { owner: 'telemetry',
      probes: [{ dst_hostname: 'pa2-bl-01', src_ip: 172.30.251.18, dst_ip: 172.30.251.17 },
             { dst_hostname: 'at1-bl-02', src_ip: 172.30.251.33, dst_ip: 172.30.251.34 }]}

# ROUTING-OPTIONS
routing_options:
  mgmt_nexthop: 10.101.14.3   # management's gateway
  router_id: 172.16.0.27        # loopback address
  autonomous_system: 53550      # Arkadin public ASN

# PROTOCOLS
protocols:
  mpls_interfaces:
  - { name: xe-0/1/2.1999 }
  - { name: xe-0/1/4.0, metric: 10 }
  - { name: xe-0/1/5.500, metric: 1700 }
  - { name: ae0.0, metric: 1 }
  - { name: ae11.10, metric: 1 }
  - { name: ae12.10, metric: 1 }
  ospf_overload: disable         # enable/disable

  # state: active/inactive
  IXRT_grp: { state: active }
  BORDER_grp: { state: inactive }
  CE_grp: { state: inactive, rr_cluster_id: 172.16.0.27,
            neighbors: [  { ip: 192.168.203.3, descr: 'ld4-ce-01' },
                          { ip: 192.168.203.4, descr: 'ld4-ce-02' } ] }
  BL_TO_BL: { state: active, ip: 172.16.0.28, descr: 'ld4-bl-02' }

# ROUTING-INSTANCES
routing_instances_vrf:
  - { name: VRF_ARKAD_INT, descr: 'Arkadin Infrastructure',
      interfaces: ['lo0.1', 'ae1.0', 'ae2.0'],
      rd_bl: 1,
      route: [ { prefix: 0.0.0.0/0, options: ['discard'] } ],
      vrf_import: 'PS_IMP_VRF-ARKAD-INT', vrf_export: 'PS_EXP_VRF-ARKAD-INT',
      groups: [ { name: SPINE_V4, state: inactive, export: PS_EXP_SPINE_V4, asdot: 200, multipath: true,
                neighbors: [ { ip: 172.22.12.3, descr: 'ld4-sp-01' }, { ip: 172.22.12.5, descr: 'ld4-sp-02' } ] } ] }

  - { name: VRF_ARKAD_EXT, descr: 'Arkadin Public Routing',
      interfaces: ['lo0.2'],
      rd_bl: 2,
      route: [ { prefix: 0.0.0.0/0, options: ['next-hop [185.37.223.28 185.37.223.36]', 'resolve'] } ],
      vrf_target: 'target:53550:2',
      groups: [ { name: INET_V4, state: active, multihop: 16, peer_as: 200077, local_address: 185.37.223.34,
                  import: PS_IMP_INET_V4, export: PS_EXP_INET_V4 } ] }

# POLICY-OPTIONS
policy_options:
  loopback_inet: 185.37.223.34/32
  local_prefixes:
  - { prefix: 192.168.3.0/24, match_type: 'prefix-length-range /32-/32' }
