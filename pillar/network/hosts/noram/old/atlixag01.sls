dc: atl
proxy:
  driver: ios
  host: atlixag01.net.arkadin.lan
region: noram
type: network
roles:
- edge_switch

topology:
  node_index: 1
  connected_devices:
    carrier_sbc:
      short_name: sbc
      tagged_interfaces:
      - TenGigabitEthernet3/1
      - GigabitEthernet4/42
      - Port-channel1
    customer_sbc:
      short_name: sbc
      tagged_interfaces:
      - TenGigabitEthernet3/1
      - GigabitEthernet4/42
      - Port-channel1
    edge_firewall:
      short_name: srx
      tagged_interfaces: []
    external_peer:
      short_name: ix
      tagged_interfaces:
      - GigabitEthernet4/43
    federated_ixrt:
      short_name: rtr
      tagged_interfaces:
      - Port-channel1
