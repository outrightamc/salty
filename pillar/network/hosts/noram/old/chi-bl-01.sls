proxy:
  host: chi-bl-01.net.arkadin.lan
  driver: junos
dc: chi
region: noram
type: network
roles:
  - border_leaf
  - fabric_spine

configuration:
  system:
    host-name: chi-bl-01
    ntp:
      source-address:
      - name: 10.100.80.60
  interfaces:
    interface:
    - description: X:chi-lf-01:et-0/0/48:fabric
      ether-options:
        ieee-802.3ad:
          bundle: ae1
      name: et-0/0/0
    - description: X:chi-lf-02:et-0/0/48:fabric
      ether-options:
        ieee-802.3ad:
          bundle: ae2
      name: et-0/0/1
    - description: X:chi-bl-02:et-0/0/3:back-to-back
      gigether-options:
        ieee-802.3ad:
          bundle: ae0
      name: et-0/0/3
    - description: Q:chi-ce-01:xe-0/0/46:edge
      ether-options:
        ieee-802.3ad:
          bundle: ae11
      name: xe-0/1/0
    - description: Q:chi-ce-02:xe-0/0/46:edge
      ether-options:
        ieee-802.3ad:
          bundle: ae12
      name: xe-0/1/1
    - description: Q:chicore01:gi4/10:legacy-integration
      gigether-options:
        '@':
          comment: /* this is required for 1g interfaces on mx204 */
        no-auto-negotiation:
        - null
        speed: 1g
      mtu: 9234
      name: xe-0/1/6
      unit:
      - description: X:atlixrt02:gi0/0/3.2083:backbone
        family:
          inet:
            address:
            - name: 172.30.251.5/30
          mpls:
          - null
        name: 2083
        vlan-id: 2083
      vlan-tagging:
      - null
    - gigether-options:
        no-auto-negotiation:
        - null
        speed: 1g
      mtu: 9234
      name: xe-0/1/7
      unit:
      - description: X:tbrixrt01:gi0/0/0.828:backbone
        family:
          inet:
            mtu: 9216
            address:
            - name: 172.30.251.13/30
          mpls:
          - null
        name: 0
    - aggregated-ether-options:
        lacp:
          active:
          - null
          periodic: fast
      description: X:chi-bl-02:ae0:back-to-back
      mtu: 9234
      name: ae0
      unit:
      - family:
          inet:
            address:
            - name: 172.22.0.0/31
          mpls:
          - null
        name: 0
    - aggregated-ether-options:
        lacp:
          active:
          - null
          periodic: fast
      description: X:chi-lf-01:ae1:fabric
      name: ae1
      unit:
      - family:
          inet:
            address:
            - name: 172.22.0.14/31
        name: 0
    - aggregated-ether-options:
        lacp:
          active:
          - null
          periodic: fast
      description: X:chi-lf-02:ae1:fabric
      name: ae2
      unit:
      - family:
          inet:
            address:
            - name: 172.22.0.16/31
        name: 0
    - aggregated-ether-options:
        lacp:
          active:
          - null
          periodic: fast
      description: Q:chi-ce-01:ae1:edge
      name: ae11
      unit:
      - family:
          inet:
            address:
            - name: 172.22.0.2/31
        name: 10
        vlan-id: 10
      vlan-tagging:
      - null
    - aggregated-ether-options:
        lacp:
          active:
          - null
          periodic: fast
      description: Q:chi-ce-02:ae1:edge
      name: ae12
      unit:
      - family:
          inet:
            address:
            - name: 172.22.0.4/31
        name: 10
        vlan-id: 10
      vlan-tagging:
      - null
    - name: fxp0
      unit:
      - family:
          inet:
            address:
            - name: 10.100.80.60/24
        name: 0
    - name: lo0
      unit:
      - family:
          inet:
            address:
            - name: 172.16.0.19/32
            filter:
              input-list:
              - ACCEPT_NETWORK_SERVICES_V4
              - ACCEPT_MGMT_SERVICES_V4
              - DISCARD_ALL_V4
        name: 0
      - family:
          inet:
            address:
            - name: 192.168.0.3/32
        name: 1
      - family:
          inet:
            address:
            - name: 185.37.223.32/32
        name: 2
  policy-options:
    policy-statement:
    - name: POL_IXRT_EXP_V4
      term:
      - from:
          community:
          - COMM_VRF_ARKAD_EXT
          route-filter:
          - address: 185.37.223.32/32
            exact:
            - null
        name: LOOPBACK_ONLY
        then:
          accept:
          - null
      - from:
          community:
          - COMM_VRF_ARKAD_EXT
        name: ARKAD_FILTER_ALL
        then:
          reject:
          - null
      - name: PERMIT_ALL
        then:
          accept:
          - null
    - name: POL_INET_EXP_V4
      term:
      - from:
          route-filter:
          - address: 185.37.223.32/32
            exact:
            - null
        name: LOOPBACK
        then:
          reject:
          - null
      - from:
          community:
          - COMM_VRF_ARKAD_EXT
        name: NO_PROPAGATE
        then:
          reject:
          - null
      - from:
          prefix-list-filter:
          - list_name: PFX_ARKAD_RIPE1_V4
            orlonger:
            - null
        name: ARKAD_PI
        then:
          accept:
          - null
      - name: REJECT_ALL
        then:
          reject:
          - null
  protocols:
    bgp:
      group:
      - authentication-key: $9$33XCn6Cp0IcyevW7Vws4of5Q39A
        export:
        - POL_IXRT_EXP_V4
        family:
          inet-vpn:
            unicast:
            - null
        local-address: 172.16.0.19
        name: IXRT
        neighbor:
        - description: pyrixrt01
          name: 172.16.0.35
        - description: pa2ixrt01
          name: 172.16.0.1
        - description: pa2ixrt02
          name: 172.16.0.2
        - description: ld4ixrt01
          name: 172.16.0.5
        - description: ld4ixrt02
          name: 172.16.0.6
        - description: tauixrt01
          name: 172.16.0.9
        - description: tauixrt02
          name: 172.16.0.10
        - description: ifcixrt01
          name: 172.16.0.13
        - description: ifcixrt02
          name: 172.16.0.14
        - description: atlixrt01
          name: 172.16.0.17
        - description: atlixrt02
          name: 172.16.0.18
        - description: sgnixrt01
          name: 172.16.0.21
        - description: sgnixrt02
          name: 172.16.0.22
        - description: tbrixrt01
          name: 172.16.0.25
        - description: tbrixrt02
          name: 172.16.0.26
        - description: shiixrt01
          name: 172.16.0.29
        - description: shiixrt02
          name: 172.16.0.30
        - description: sjcixrt01
          name: 172.16.0.31
        - description: sjcixrt02
          name: 172.16.0.32
        - description: pyrixrt02
          name: 172.16.0.36
        peer-as: "53550"
        vpn-apply-export:
        - null
      - authentication-key: $9$33XCn6Cp0IcyevW7Vws4of5Q39A
        description: intra-DC PE routers
        family:
          inet-vpn:
            unicast:
            - null
        local-address: 172.16.0.19
        name: BL_TO_BL
        neighbor:
        - description: chi-bl-02
          name: 172.16.0.20
        peer-as: "53550"
      - authentication-key: $9$33XCn6Cp0IcyevW7Vws4of5Q39A
        description: inter-DC PE routers
        export:
        - POL_BORDER_EXP_V4
        family:
          inet-vpn:
            unicast:
            - null
        local-address: 172.16.0.19
        name: BORDER
        peer-as: "53550"
        vpn-apply-export:
        - null
    ldp:
      interface:
      - name: xe-0/1/6.2083
      - name: xe-0/1/7.0
      - name: ae0.0
    lldp:
      interface:
      - name: all
      port-description-type: interface-description
      port-id-subtype: interface-name
    mpls:
      interface:
      - name: ae0.0
      - name: xe-0/1/6.2083
      - name: xe-0/1/7.0
    ospf:
      area:
      - interface:
        - authentication:
            md5:
            - key: $9$f5TF69pBIhSrMX7NbwHk.fz3
              name: 0
          dead-interval: 3
          hello-interval: 1
          interface-type: p2p
          ldp-synchronization:
          - null
          metric: 1
          name: ae0.0
        - name: lo0.0
          passive:
          - null
        - authentication:
            md5:
            - key: $9$VTbw2oJDk.fTz/tu0IRXxNVYg
              name: 1
          dead-interval: 3
          hello-interval: 1
          interface-type: p2p
          ldp-synchronization:
          - null
          metric: 1700
          name: xe-0/1/6.2083
        - authentication:
            md5:
            - key: $9$VTbw2oJDk.fTz/tu0IRXxNVYg
              name: 1
          dead-interval: 3
          hello-interval: 1
          interface-type: p2p
          ldp-synchronization:
          - null
          metric: 2000
          name: xe-0/1/7.0
        name: 0.0.0.0
      reference-bandwidth: 100g
  routing-instances:
    instance:
    - description: Arkadin Public Routing
      instance-type: vrf
      interface:
      - name: lo0.2
      name: VRF_ARKAD_EXT
      protocols:
        bgp:
          group:
          - export:
            - POL_INET_EXP_V4
            import:
            - POL_INET_IMP_V4
            local-address: 185.37.223.32
            log-updown:
            - null
            multihop:
              ttl: 16
            name: INET
            neighbor:
            - description: atlinet01
              name: 185.37.223.16
            - description: atlinet02
              name: 185.37.223.17
            - description: ifcinet01
              name: 185.37.223.22
            - description: ifcinet02
              name: 185.37.223.23
            - description: ld4inet01
              name: 185.37.223.20
            - description: pa2inet01
              name: 185.37.223.21
            - description: pyrinet01
              name: 185.37.223.26
            - description: pyrinet02
              name: 185.37.223.27
            - description: sgninet01
              name: 185.37.223.31
            - description: shiinet01
              name: 185.37.223.18
            - description: shiinet02
              name: 185.37.223.19
            - description: sjcinet01
              name: 185.37.223.24
            - description: sjcinet02
              name: 185.37.223.25
            peer-as: "200077"
            type: external
      route-distinguisher:
        rd-type: 172.16.0.19:2
      vrf-table-label:
      - null
      vrf-target:
        community: target:53550:2
    - description: Arkadin Infrastructure
      instance-type: vrf
      interface:
      - name: ae1.0
      - name: ae2.0
      - name: ae11.10
      - name: ae12.10
      - name: lo0.1
      name: VRF_ARKAD_INT
      protocols:
        bgp:
          group:
          - export:
            - POL_LEAF_EXP_V4
            family:
              inet:
                unicast:
                - null
            log-updown:
            - null
            multipath:
              multiple-as:
              - null
            name: LEAF
            neighbor:
            - description: chi-lf-01
              name: 172.22.0.15
              peer-as: "64100.1"
            - description: chi-lf-02
              name: 172.22.0.17
              peer-as: "64100.2"
            type: external
          - cluster: 172.16.0.19
            export:
            - POL_CE_EXP_V4
            family:
              inet:
                unicast:
                - null
            log-updown:
            - null
            multipath:
            - null
            name: CE
            neighbor:
            - description: chi-ce-01
              name: 172.22.0.3
            - description: chi-ce-02
              name: 172.22.0.5
            peer-as: "53550"
            type: internal
      route-distinguisher:
        rd-type: 172.16.0.19:1
      routing-options:
        static:
          route:
          - discard:
            - null
            name: 0.0.0.0/0
      vrf-export:
      - POL_VRF_ARKAD_INT_EXP
      vrf-import:
      - POL_VRF_ARKAD_INT_IMP
      vrf-table-label:
      - null
  routing-options:
    autonomous-system:
      as-number: "53550"
      asdot-notation:
      - null
    forwarding-table:
      export:
      - POL_ECMP
    router-id: 172.16.0.19
    static:
      route:
      - name: 0.0.0.0/0
        next-hop:
        - 10.100.80.254
