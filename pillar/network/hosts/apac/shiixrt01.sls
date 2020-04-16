dc: shi
proxy: {driver: ios, host: shiixrt01.net.arkadin.lan, optional_args: {global_delay_factor: 2}}
region: apac
type: network
roles: [mpls_pe]

topology:
  node_index: 1
  mpls_loopback: 172.16.0.29
  connected_devices:
    carrier_sbc: { short_name: sbc, tagged_interfaces: [ "GigabitEthernet0/0/1" ] }
    customer_sbc: { short_name: sbc, tagged_interfaces: [ "GigabitEthernet0/0/1" ] }
    edge_firewall: { short_name: srx, tagged_interfaces: [ "GigabitEthernet0/0/1" ] }
    external_peer: { short_name: ix, tagged_interfaces: [ "GigabitEthernet0/0/2" ] }
