#!jinja|yaml|gpg
peerings:
  - id: VRF_NTT_SIP
    version: 2
    state: present
    description: NTT SIP Trunking
    local: { device: carrier_sbc, network: 10.133.3.16/28, vlan: 3009, node_group: local_dev_a }
    routing:
      vrf: { id: 114, allocation_type: unique }
      static:
        - { network: 10.133.2.0/24 }
    ix_group:
      - network: 10.133.3.0/30
        node_group: path_a
        vlan: 3508
        bandwidth: 1000
        connection:
          - { switch: shiixag01, port: GigabitEthernet4/6, circuit_id: N190029856 }
  - id: VRF_NTT_SIP
    version: 2
    state: present
    description: NTT SIP Trunking
    local: { device: carrier_sbc, network: 10.133.3.32/28, vlan: 3010, node_group: local_dev_b }
    routing:
      vrf: { id: 114, allocation_type: unique }
      static:
        - { network: 10.133.2.0/24 }
    ix_group:
      - network: 10.133.3.4/30
        node_group: path_b
        vlan: 3509
        preference: standby
        bfd: false
        bandwidth: 1000
        connection:
          - { switch: shiixag02, port: GigabitEthernet4/6, circuit_id: N190029857 }
  - id: VRF_AMZN_SIP
    version: 2
    state: present
    description: Amazon SIP Trunking
    local: { device: customer_sbc, network: 10.5.1.16/28, vlan: 3008, node_group: local_dev }
    routing:
      vrf: { id: 110, allocation_type: unique }
      bgp:
        asn: 65000
        password:
          -----BEGIN PGP MESSAGE-----

          hQIMA7EyDH5sxwv4AQ/+Lhv4Em75BiUYyBCC1+kXeKIaISrzF0nGEuiVZ3pnRPdl
          z+z5z6ZIVmuuVm7Uzxed/CrwMatI33aVpIVMDmFVX2RIsRoYPTzBczJ8B4YDIf5a
          eRsGrjvPvgqj+BSu3MfRg0+oXv2ShCaMH+k+DpyzEbfD+wQZ1M0OkJhDMIxi3qGf
          TR/OBh+un8mF5dNWDCF8lp/qF8uiqdUDQk3IFU2uT7D2nEweswET1fNKDqE65aMJ
          oMkh03eLtLqL7ZU3kvgJGVndpylp+T0TQLj6QnMK2yWhieOcdhxd40hC2j4cS6KV
          Evh4Fxf4HP4yQJD0QZitun8zW65/t4MdLvU5W0kFUuSgMmQ8G4TdflyzTrWVP2BA
          hBwso+Jh+MHGNGARHtEuk/8kZnGzVvSnb483dC4dC04YdMaGKVU9lSd7ALSiNINF
          WX7zcLCvtwFnjEJkXlyQJrmuPmEKsvrAJ+9hcjudIsZx3ReON+T3VagjsBZsLjgW
          jHhyqcH5oiuXSHYvjsiGeQlV+FTW9O+yuMDFy6TWu/z7QgixrI8NlgifK0KTg3KQ
          nwaMLNR6onbW/2yzB5UlfEFsv+TFsL58HZzHbOb2KzbolAdtjnUcPVdBVRIaECwU
          aFxr3A6x2K+/U21pHLRlfUzpkXo5zdsWbljjR4LEqY0E8HjY86SFBY0la48dzQrS
          SwEAlNXalMgahtDrFRhXzJXrLIxYxugFLUIgeo5C0lpxBC8cpRjaQMYcRcm09v5/
          ph3HjPhMDTM8H/kqPtOfgR9RXd0e/BdUxoQGpA==
          =qFyt
          -----END PGP MESSAGE-----
        import_filter:
          - 10.5.0.0/24
          - 10.5.4.0/24
        export_filter_append:
          - 10.5.4.0/24
          - 10.5.0.0/24
    ix_group:
      - network: 10.5.1.0/30
        node_group: path_a
        vlan: 3506
        preference: primary
        bfd: true
        bandwidth: 1000
        connection:
          - { switch: shiixag01, port: GigabitEthernet4/7, tagged: true, circuit_id: N190001112 }
      - network: 10.5.1.4/30
        node_group: path_b
        vlan: 3507
        preference: standby
        bfd: true
        bandwidth: 1000
        connection:
          - { switch: shiixag02, port: GigabitEthernet4/7, tagged: true, circuit_id: N190001008 }
