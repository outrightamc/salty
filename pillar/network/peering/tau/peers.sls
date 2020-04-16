#!jinja|yaml|gpg
peerings:
  - id: ext_cust_broadsoft
    state: present
    description: Broadsoft BroadCloud Customers
    local: { device: customer_sbc, network: 10.0.56.128/28, vlan: 3010, node_group: local_dev }
    routing:
      vrf: { allocation_type: legacy, rd: '53550:493010', rt: '53550:3010' }
      bgp:
        asn: 35180
        password: |
          -----BEGIN PGP MESSAGE-----

          hQIMA7EyDH5sxwv4AQ//Z8RPwroRCgnfLRrcAZCjIplq/l6c4+6xFWW7X/IEat3l
          zfntzQerXvFC/6dtW81LbOQUEcAun+PtM5qEk5sgmhlGg3wx98Mt71oEIVj07HRj
          B0aSFn30lKw80LNJA/yeUB7UnBGJa0ehkhszc876TDbsm9LEQXLMPF9vIA8hIOtm
          qB5cDTMKxxcG/PDhVS23Ur9P8UjwlUXKgRdbnANDXIRCtZ2wnDQnoPYM132flswj
          yq01Re33pXYbTveVAoxxFaqAy0JdOFzn+gojPNQX79XW0idyMEvL951TZopLoKRs
          Ut8cJzFZ97yTZIxv2/PKMl/lOklp02L6kuFw9g2R+qjz12SxNJH1Q5g4wGqN4QaI
          4VkXimC5F5l6/l4ToKqkWBZrbsQl3LxO0h/LS9Bn7mXdPWt6nnAbUNPVDJlw1uOw
          ozBjVvzJXFM/p+DD2YV1R0znqcBj+TFCfFoGTwZkebrxbnXhA72ge+QqsfXf6d/r
          esOTTIn++6ylSQfDyQ8sX4U4t/hNyRh9MV4c/IDRyajLNTTJrcvuB/Npnp4PRJei
          DTMPoqaE3K+GUoueU5pKAybuhdWvfg/1GjXUnY4c+ugre81PjiGLAwL7714hc0bQ
          7pHh/OxI6ScAednMlirZednhu9+FneoRVJWv2AhXi3sfMJZnO3YmeCQHuySZhSfS
          UgGIQ4dzFFLCQROrIYh7jXKhl+zslFvUKPsgZH4EEZ4PPlCZUqLfe6bZkklQKj7D
          T57A6lEnRqVu6ENOialewXlaulOBcUqf0pUr82o3hWf/K9Y=
          =u7gE
          -----END PGP MESSAGE-----
        import_filter:
          - 85.119.56.0/25
        export_filter_append:
          - 10.0.57.128/28
    ix_group:
      - network: 172.24.3.0/29
        node_group: dual_rtr
        vlan: 3510
        reverse_ip: true
        preference: tauixrt01
        bfd: true
        bandwidth: 100
        connection:
          - { switch: tauixag01, port: GigabitEthernet2/5, circuit_id: ID_MISSING, tagged: true }

  - id: VRF_CISCO_PMP-SIP
    version: 2
    state: present
    description: Cisco Webex PMP SIP
    local: { device: customer_sbc, network: 185.37.220.232/29, vlan: 3012, node_group: local_dev }
    routing:
      vrf: { allocation_type: unique, id: 115 }
      bgp:
        asn: 35180
        import_filter:
          - 85.119.56.0/24
          - 185.115.197.0/24
    ix_group:
      - network: 10.190.0.24/31
        node_group: path_a
        vlan: 3512
        reverse_ip: true
        bfd: true
        bandwidth: 100
        connection:
          - { switch: tauixag01, port: GigabitEthernet2/5, circuit_id: CCID_ETYX/171916//ZYO, tagged: true, check_override: broadsoft }
