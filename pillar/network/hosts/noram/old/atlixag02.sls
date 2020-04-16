dc: atl
proxy:
  driver: ios
  host: atlixag02.net.arkadin.lan
region: noram
type: network
roles:
- edge_switch

topology:
  node_index: 2
  connected_devices:
    carrier_sbc:
      short_name: sbc
      tagged_interfaces:
      - TenGigabitEthernet3/1
      - GigabitEthernet2/42
      - Port-channel1
    customer_sbc:
      short_name: sbc
      tagged_interfaces:
      - TenGigabitEthernet3/1
      - GigabitEthernet2/42
      - Port-channel1
    edge_firewall:
      short_name: srx
      tagged_interfaces: []
    external_peer:
      short_name: ix
      tagged_interfaces:
      - GigabitEthernet2/43
    federated_ixrt:
      short_name: rtr
      tagged_interfaces:
      - Port-channel1
