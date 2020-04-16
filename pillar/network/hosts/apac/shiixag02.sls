proxy:
  driver: ios
  host: shiixag02.net.arkadin.lan
  optional_args:
    global_delay_factor: 2
dc: shi
region: apac
type: network
roles:
- edge_switch

topology:
  node_index: 2
  connected_devices:
    carrier_sbc:
      short_name: sbc
      tagged_interfaces:
      - GigabitEthernet4/5      #down to shi-ce
      - GigabitEthernet2/44     #to router internal int
      - Port-channel1           #to other ixag
    customer_sbc:
      short_name: sbc
      tagged_interfaces:
      - GigabitEthernet4/5      #down to shi-ce
      - GigabitEthernet2/44     #to router internal int
      - Port-channel1           #to other ixag
    external_peer:
      short_name: ix
      tagged_interfaces:
      - GigabitEthernet2/45     #to router customer int
    federated_ixrt:
      short_name: rtr
      tagged_interfaces:
      - Port-channel1
