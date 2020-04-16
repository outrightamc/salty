proxy:
  host: shi-ce-02.net.arkadin.lan
  driver: junos
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
      - ae0
      - ge-0/0/29
      - xe-0/0/0
    customer_sbc:
      short_name: sbc
      tagged_interfaces:
      - ae0
      - ge-0/0/28
      - xe-0/0/0
    external_peer:
      short_name: ix
      tagged_interfaces:
      - ge-0/0/28
    federated_ixrt:
      short_name: rtr
      tagged_interfaces:
      - ae0
