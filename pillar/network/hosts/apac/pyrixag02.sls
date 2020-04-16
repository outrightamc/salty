dc: pyr
proxy: {driver: ios, host: pyrixag02.net.arkadin.lan, optional_args: {global_delay_factor: 2}}
region: apac
type: network
roles: [edge_switch]

topology:
  node_index: 2
  connected_devices:
    carrier_sbc: { short_name: sbc, tagged_interfaces: [ "GigabitEthernet1/0/42", "GigabitEthernet1/0/26", "Port-channel1" ] }
    customer_sbc: { short_name: sbc, tagged_interfaces: [ "GigabitEthernet1/0/42", "GigabitEthernet1/0/27", "Port-channel1" ] }
    edge_firewall: { short_name: srx, tagged_interfaces: [ ] }
    external_peer: { short_name: ix, tagged_interfaces: [ "GigabitEthernet1/0/43" ] }
    federated_ixrt: { short_name: rtr, tagged_interfaces: [ "Port-channel1" ] }
