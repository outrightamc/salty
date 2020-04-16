dc: atl
proxy:
  driver: junos
  host: atl-fw-01.net.arkadin.lan
region: noram
roles:
- firewall
type: network

interface_monitor:
  1:
    - ge-0/0/1
    - ge-4/0/1
    - ge-0/0/0
    - ge-4/0/0
  2:
    - ge-0/0/3
    - ge-4/0/3
