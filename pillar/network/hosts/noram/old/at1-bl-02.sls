proxy:
  host: at1-bl-02.net.arkadin.lan
  driver: junos

dc: at1
region: noram
type: network

# ASN ASSIGNEMENT https://netwiki.net.arkadin.lan/resources/asn
fabric_asn: 64101

# INTERFACES CONFIGURATION https://netwiki.net.arkadin.lan/resources/ipfabricaddr
interfaces:

# PHYSICAL https://netwiki.net.arkadin.lan/standards/mx204ports
# physical > name, description, state: enable/disable, lacp for aggregated interface, mtu
  - { name: et-0/0/0, descr: 'X:at1-lf-01:et-0/0/0:fabric', state: enable, lacp: ae1 }
  - { name: et-0/0/1, descr: 'X:at1-lf-02:et-0/0/0:fabric', state: enable, lacp: ae2 }
  - { name: et-0/0/3, descr: 'X:at1-bl-01:et-0/0/3:b2b', state: enable, lacp: ae0 }
  - { name: xe-0/1/0, descr: 'Q:at1-ce-01:xe-0/0/46:ce', state: disable, lacp: ae11 }
  - { name: xe-0/1/1, descr: 'Q:at1-ce-02:xe-0/0/46:ce', state: disable, lacp: ae12 }

# AGGREGATE LACP https://netwiki.net.arkadin.lan/standards/ae
# subinterface or ae > unit vlan ID, description, state: enable/disable, mpls: true/false
  - { name: ae0, descr: 'X:at1-bl-02:ae0.0:b2b', mtu: 9234, unit: {id: 0, address: 172.22.4.1/31, mpls: true} }
  - { name: ae1, descr: 'X:at1-lf-01:ae1.0:fabric', mtu: 9234, unit: {id: 10, address: 172.22.4.6/31} }
  - { name: ae2, descr: 'X:at1-lf-02:ae1.0:fabric', mtu: 9234, unit: {id: 10, address: 172.22.4.8/31} }
  - { name: ae11, descr: 'Q:at1-ce-01:ae1.10:ce', mtu: 1600, unit: {id: 10, address: 172.22.4.36/31, mpls: true} }
  - { name: ae12, descr: 'Q:at1-ce-02:ae1.10:ce', mtu: 1600, unit: {id: 10, address: 172.22.4.38/31, mpls: true} }

# OOB FXP0
  - { name: fxp0, descr: 'M:10.122.128.0/24:mgmt', unit: {id: 0, address: 10.122.128.129/24} }

# LOOPBACK https://netwiki.net.arkadin.lan/resources/ipfabricaddr#loopbacks
  - { name: lo0, descr: 'L:192.168.201.2/32:backbone', unit: {id: 0, address: 192.168.201.2/32} }
  - { name: lo0, descr: 'L:192.168.1.2/32:border', unit: {id: 1, address: 192.168.1.2/32} }
  - { name: lo0, descr: 'L:185.37.223.39/32:inet', unit: {id: 2, address: 185.37.223.39/32} }

# IXRT LEGACY 1G or 10G
  - { name: ae2, descr: 'X:at1-lf-02:ae1.0:fabric', state: enable, mtu: 9234, unit: {id: 501, descr: 'X:atlixrt01:gi0/0/0.501:backbone', address: 172.30.251.249/30, mpls: true}}

# UPLINKS BACKBONE 1G or 10G 172.30.251.0/24 https://device42.arkadin.lan/admin/rackraj/vlan/530/
# 1580 bytes (1500 ethernet payload + 14 Ethernet + 50 VXLAN (8+8+14+20) + 12 MPLS + 4 VLAN).
  - { name: xe-0/1/4, descr: 'E:ETYX/236871//ZYO:ld4-bl-01:backbone',
      state: enable, mtu: 1580, speed1g: true,
      unit: { id: 500, descr: 'X:ld4-bl-01:xe-0/1/5.500', address: 172.30.251.34/30, mpls: true } }

# RPM PROBES
rpm:
  - { owner: 'telemetry', probes: [{ dst_hostname: 'ld4-bl-01', src_ip: 172.30.251.34, dst_ip: 172.30.251.33 }]}

# ROUTING-OPTIONS
routing_options:
  mgmt_nexthop: 10.122.128.254  # management's gateway
  router_id: 192.168.201.2      # loopback address
  autonomous_system: 53550      # Arkadin public ASN

# PROTOCOLS - { name: itf-name, metric: cost, (passive: True) }
protocols:
  mpls_interfaces:
  - { name: xe-0/1/4.500, metric: 1700 }
  - { name: ae0.0, metric: 1 }
  - { name: ae2.501, metric: 1000 }
  ospf_overload: disable         # enable/disable

  # state: active/inactive
  IXRT_grp: { state: active }
  BORDER_grp: { state: active }
  CE_grp: { state: inactive, rr_cluster_id: 192.168.201.1,
            neighbors: [  { ip: 192.168.201.3, descr: 'at1-ce-01' },
                          { ip: 192.168.201.4, descr: 'at1-ce-02' } ] }
  BL_TO_BL: { state: active, ip: 192.168.201.1, descr: 'at1-bl-01' }

# ROUTING-INSTANCES
routing_instances_vrf:
  - name: VRF_ARKAD_INT
    descr: 'Arkadin Infrastructure'
    interfaces: ['lo0.1', 'ae1.10', 'ae2.10']
    rd_bl: 1
    route: []
    vrf_import: 'PS_IMP_VRF-ARKAD-INT'
    vrf_export: 'PS_EXP_VRF-ARKAD-INT'
    groups:
      - name: LEAF_V4
        state: active
        export: PS_EXP_SPINE_V4
        import: PS_SET_LP
        multipath: true
        neighbors:
          - { ip: 172.22.4.7, descr: 'at1-lf-01', asdot: 1 }
          - { ip: 172.22.4.9, descr: 'at1-lf-02', asdot: 2 }

  - { name: VRF_ARKAD_EXT, descr: 'Arkadin Public Routing',
      interfaces: ['lo0.2'],
      rd_bl: 2,
      route: [ { prefix: 0.0.0.0/0, options: ['next-hop [185.37.223.16 185.37.223.17]', 'resolve'] } ],
      vrf_target: 'target:53550:2',
      groups: [ { name: INET_V4, state: inactive, multihop: 16, peer_as: 200077, local_address: 185.37.223.38,
                  import: PS_IMP_INET_V4, export: PS_EXP_INET_V4 } ] }

# POLICY-OPTIONS
policy_options:
  loopback_inet: 185.37.223.39/32
  local_prefixes:
    - { prefix: 10.0.1.0/24, match_type: 'orlonger' }
    - { prefix: 10.100.0.0/16, match_type: 'orlonger' }
    - { prefix: 10.122.0.0/16, match_type: 'exact' }
    - { prefix: 10.200.0.0/16, match_type: 'exact' }
    - { prefix: 10.222.4.79/32, match_type: 'exact' }
    - { prefix: 172.16.83.0/24, match_type: 'exact' }
    - { prefix: 172.16.90.10/32, match_type: 'exact' }
    - { prefix: 172.16.90.11/32, match_type: 'exact' }
    - { prefix: 172.22.4.0/22, match_type: 'exact' }
    - { prefix: 172.31.252.8/29, match_type: 'exact' }
    - { prefix: 192.168.1.0/24, match_type: 'exact' }
