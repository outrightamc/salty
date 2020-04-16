dc: ld4
proxy: {driver: ios, host: ld4ixag01.net.arkadin.lan, optional_args: {global_delay_factor: 2}}
region: emea
type: network
roles: [edge_switch]

topology:
  node_index: 1
  connected_devices:
    carrier_sbc: { short_name: sbc, tagged_interfaces: [ "GigabitEthernet1/0/42", "GigabitEthernet1/0/38", "Port-channel1" ] }
    customer_sbc: { short_name: sbc, tagged_interfaces: [ "GigabitEthernet1/0/42", "GigabitEthernet1/0/40", "Port-channel1" ] }
    edge_firewall: { short_name: srx, tagged_interfaces: [ ] }
    external_peer: { short_name: ix, tagged_interfaces: [ "Port-channel2", "GigabitEthernet1/0/43" ] }
    federated_ixrt: { short_name: rtr, tagged_interfaces: [ "Port-channel1" ] }
