proxy:
  host: tau-bl-01.net.arkadin.lan
  driver: junos

dc: tau
region: emea
type: network

# WORKAROUND PROBLEM REPORT http://prsearch.juniper.net/PR1398398
processes:
  disable:
    - na-grpc-server
    - jsd

# ASN ASSIGNEMENT https://netwiki.net.arkadin.lan/resources/asn
fabric_asn: 64302

# INTERFACES CONFIGURATION https://netwiki.net.arkadin.lan/resources/ipfabricaddr
interfaces:

# PHYSICAL https://netwiki.net.arkadin.lan/standards/mx204ports
# physical > name, description, state: enable/disable, lacp for aggregated interface, mtu
  - { name: et-0/0/0, descr: 'X:tau-sp-01:et-0/0/0:spine', state: disable, lacp: ae1 }
  - { name: et-0/0/1, descr: 'X:tau-sp-02:et-0/0/0:spine', state: disable, lacp: ae2 }
  - { name: xe-0/1/3, descr: 'X:tau-bl-02:xe-0/1/3:b2b', state: enable, lacp: ae0 }
  - { name: xe-0/1/0, descr: 'Q:tau-ce-01:xe-0/0/46:ce', state: disable, lacp: ae11 }
  - { name: xe-0/1/1, descr: 'Q:tau-ce-02:xe-0/0/46:ce', state: disable, lacp: ae12 }

# AGGREGATE LACP https://netwiki.net.arkadin.lan/standards/ae
# subinterface or ae > unit vlan ID, description, state: enable/disable, mpls: true/false
  - { name: ae0, descr: 'X:tau-bl-01:ae0:b2b', mtu: 9234, unit: {id: 0, address: 172.22.16.0/31, mpls: true} }
  - { name: ae1, descr: 'X:tau-sp-01:ae31:spine', unit: {id: 0, address: 172.22.16.2/31} }
  - { name: ae2, descr: 'X:tau-sp-02:ae31:spine', unit: {id: 0, address: 172.22.16.4/31} }
  - { name: ae11, descr: 'Q:ld4-ce-01:ae1.10:ce', mtu: 1600, unit: {id: 10, address: 172.22.16.32/31, mpls: true} }
  - { name: ae12, descr: 'Q:ld4-ce-02:ae1.10:ce', mtu: 1600, unit: {id: 10, address: 172.22.16.34/31, mpls: true} }

# OOB FXP0
  - { name: fxp0, descr: 'M:10.105.11.0/24:mgmt', unit: {id: 0, address: 10.105.11.230/24} }

# LOOPBACK https://netwiki.net.arkadin.lan/resources/ipfabricaddr#loopbacks
  - { name: lo0, descr: 'L:172.16.0.33/32:legacy', unit: {id: 0, address: 172.16.0.33/32} }
  - { name: lo0, descr: 'L:192.168.4.1/32:border', unit: {id: 1, address: 192.168.4.1/32} }
  - { name: lo0, descr: 'L:185.37.223.36/32:inet', unit: {id: 2, address: 185.37.223.36/32} }

# IXRT LEGACY 1G https://device42.arkadin.lan/admin/rackraj/vlan/309/
  - { name: xe-0/1/4, descr: 'Q:tauixag01:Gi3/20:ixag', state: enable, mtu: 9234,
  unit: {id: 1999, descr: 'X:tauixrt01:Gi0/0/0.1999', mtu: 9216, address: 172.22.18.0/31, mpls: true}}

# UPLINKS BACKBONE 1G or 10G 172.30.251.0/24 https://device42.arkadin.lan/admin/rackraj/vlan/530/
# 1580 bytes (1500 ethernet payload + 14 Ethernet + 50 VXLAN (8+8+14+20) + 12 MPLS + 4 VLAN).
  - { name: xe-0/1/6, descr: 'E:COLT_PAR/FRA/LE-517467:NTT-SID-EU-01611459:pa2-bl-02:backbone', state: enable, mtu: 1580,
  unit: {id: 0, descr: 'X:pa2-bl-02:xe-0/1/4.0', address: 172.30.251.22/30, mpls: true}}

# RPM PROBES
rpm:
  - { owner: 'telemetry',
      probes: [{ dst_hostname: 'pa2-bl-02', src_ip: 172.30.251.22, dst_ip: 172.30.251.21 }]}

# ROUTING-OPTIONS
routing_options:
  mgmt_nexthop: 10.105.11.254   # management's gateway
  router_id: 172.16.0.33        # loopback address
  autonomous_system: 53550      # Arkadin public ASN

# PROTOCOLS
protocols:
  mpls_interfaces:
  - { name: xe-0/1/4.1999 }
  - { name: xe-0/1/6.0, metric: 10 }
  - { name: ae0.0, metric: 1 }
  - { name: ae11.10, metric: 1 }
  - { name: ae12.10, metric: 1 }
  ospf_overload: disable         # enable/disable

# state: active/inactive
  IXRT_grp: { state: active }  
  BORDER_grp: { state: inactive }
  CE_grp: { state: inactive, rr_cluster_id: 172.16.0.33,
            neighbors: [  { ip: 192.168.204.3, descr: 'tau-ce-01' },
                          { ip: 192.168.204.4, descr: 'tau-ce-02' } ] }
  BL_TO_BL: { state: active, ip: 172.16.0.34, descr: 'tau-bl-02' }

# ROUTING-INSTANCES
routing_instances_vrf:
  - { name: VRF_ARKAD_INT, descr: 'Arkadin Infrastructure',
      interfaces: ['lo0.1', 'ae1.0', 'ae2.0'],
      rd_bl: 1,
      route: [ { prefix: 0.0.0.0/0, options: ['discard'] } ],
      vrf_import: 'PS_IMP_VRF-ARKAD-INT', vrf_export: 'PS_EXP_VRF-ARKAD-INT',
      groups: [ { name: SPINE_V4, state: inactive, export: PS_EXP_SPINE_V4, asdot: 200, multipath: true,
                neighbors: [ { ip: 172.22.16.3, descr: 'tau-sp-01' }, { ip: 172.22.16.5, descr: 'tau-sp-02' } ] } ] }

  - { name: VRF_ARKAD_EXT, descr: 'Arkadin Public Routing',
      interfaces: ['lo0.2'],
      rd_bl: 2,
      route: [ { prefix: 0.0.0.0/0, options: ['next-hop [185.37.223.28 185.37.223.34]', 'resolve'] } ],
      vrf_target: 'target:53550:2',
      groups: [ { name: INET_V4, state: active, multihop: 16, peer_as: 200077, local_address: 185.37.223.36,
                  import: PS_IMP_INET_V4, export: PS_EXP_INET_V4 } ] }

# POLICY-OPTIONS
policy_options:
  loopback_inet: 185.37.223.36/32
  local_prefixes:
  - { prefix: 192.168.4.0/24, match_type: 'prefix-length-range /32-/32' }
