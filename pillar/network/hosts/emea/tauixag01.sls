dc: tau
proxy: {driver: ios, host: tauixag01.net.arkadin.lan}
region: emea
type: network
roles: [edge_switch]

topology:
  node_index: 1
  connected_devices:
    carrier_sbc: { short_name: sbc, tagged_interfaces: [ "GigabitEthernet3/43", "GigabitEthernet3/30", "Port-channel1" ] }
    customer_sbc: { short_name: sbc, tagged_interfaces: [ "GigabitEthernet3/43", "GigabitEthernet3/29", "Port-channel1" ] }
    edge_firewall: { short_name: srx, tagged_interfaces: [ ] }
    external_peer: { short_name: ix, tagged_interfaces: [ "GigabitEthernet3/44" ] }
    federated_ixrt: { short_name: rtr, tagged_interfaces: [ "Port-channel1" ] }
