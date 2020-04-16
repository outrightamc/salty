dc: ld4
proxy:
  driver: junos
  host: ld4-ce-01.net.arkadin.lan
region: emea
type: network
roles:
- edge_switch
- fabric_ce
topology:
  node_index: 1
  connected_devices:
    carrier_sbc:
      short_name: sbc
      tagged_interfaces: []
    customer_sbc:
      short_name: sbc
      tagged_interfaces: []
    edge_firewall:
      short_name: srx
      tagged_interfaces:
      - ae1
    external_peer:
      short_name: ix
      tagged_interfaces:
      - ae1
    federated_ixrt:
      short_name: rtr
      tagged_interfaces:
      - ae0

vlans:
  - {id: 1, name: test_1}
  - {id: 2, name: test_2}
