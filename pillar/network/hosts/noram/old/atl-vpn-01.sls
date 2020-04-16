dc: atl
proxy:
  driver: junos
  host: atl-vpn-01.net.arkadin.lan
region: noram
roles:
- vpn_concentrator
type: network

interface_monitor:
  1:
    - ge-0/0/5
    - ge-9/0/5
    - ge-0/0/4
    - ge-9/0/4
