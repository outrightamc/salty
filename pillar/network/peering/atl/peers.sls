#!jinja|yaml|gpg
peerings:
  - id: ext_cust_broadsoft
    state: present
    description: Broadsoft BroadCloud Customers
    local: { device: customer_sbc, network: 10.0.65.128/28, vlan: 3010, node_group: local_dev }
    routing:
      vrf:
        id: 3010
        allocation_type: unique
      bgp:
        asn: 21534
        timers: { keep_alive: 10, hold_down: 30 }
        password: |
          -----BEGIN PGP MESSAGE-----

          hQIMA7EyDH5sxwv4ARAAmreu54ojvjSSVx7TixieEWLcU0pxuP454qDHJa3Cofqh
          8WwDVOXwFoYmE4DyXmUCph6X8OTxWnuYTCBS9n5BL8cYS/1Mq1UhWHTSMc0CQ3lp
          5GlTeD9KQGKieNdqFwtnyyWr0sVoIHgx1BciD+Xz/3vwvGecgSJEMVmnw2Z0Vd5N
          Az6shDypj1tAE5SX+LZrhW/fExQ+XwV4PyikZYFEhrmdIVDg6SltSLIoiDYTg2/U
          1QOfKWWbQpYT9Becuq59RXZfa88WwCnu8MkapI4/vhTuVVF6vngVh7jN2krm/qq9
          Psvo587Wb6uDEjIzzcKwHHiLmMqnAbUG32XBcqofSQtRrs+KJ9KHWkPIqmweUmUg
          AXORIUVfrnlDLAZLyRwIY/nI3wDvcx+fpAAE43zIg6vNb//q6KFy9AtMFPZF1YlE
          LZLkvG1Lga39OwCPh2wCIqpEbDFAztTnKFbndSe1XqDnDvX4zuyYGTMFwiJ4WEAJ
          ZGWQfKfA/CQ5V69fqYDhnSm5G2kqZrh0nwyrwpku/elYOnKrBcNKfC1RBzRq1wyX
          EGD3HbH/n1czgT+b0Ypqbz+iBw6C3cGaYIy1dIPsRPd/OmKfUgbUcONT08ozwcRo
          +JSsPmwQ1y3Fy0zOJpJ4ly29PvNOB0a30Br7UAGjNb4xcSKO23s2tekZAp3aOoDS
          SgEyZqhM6DMqsqFiFx7e/cqC/OKIPzpCKtNVmVVM2Y67lIVzI0TZtonBmc0jfiav
          YX5rUIBji8WNXb6jmakk8bjELz7pj76tDJd3
          =hrf/
          -----END PGP MESSAGE-----
        import_filter:
          - 199.59.65.0/25
    ix_group:
      - network: 10.0.65.0/29
        node_group: dual_rtr
        vlan: 3520
        reverse_ip: true
        preference: atlixrt02
        bfd: true
        bandwidth: 100
        connection:
          - { switch: atlixag01, port: GigabitEthernet2/7, circuit_id: "EQ-20954674/HE-3989925", tagged: false }
            
#  - id: ext_cust_sip_thermofisher
#    state: present
#    description: Thermofisher
#    local: { device: customer_sbc, network: 10.166.232.128/28, vlan: 3011, node_group: local_dev }
#    routing:
#      vrf: { id: 3011, allocation_type: unique }
#      bgp:
#        asn: 21534
#        custom_policy:
#          import: POL_THERMOFISHER_IM
#          export: POL_THERMOFISHER_EX
#        timers: { keep_alive: 10, hold_down: 30 }
#        password: |
#    ix_group:
#      - network: 10.166.232.0/29
#        node_group: dual_rtr
#        vlan: 3521
#        bfd: true
#        bandwidth: 100
#        connection:
#          - { switch: atlixag02, port: GigabitEthernet2/3, circuit_id: circuit-id-undefined, tagged: false }
