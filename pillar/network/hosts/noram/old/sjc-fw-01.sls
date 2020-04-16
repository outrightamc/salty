dc: sjc
proxy:
  driver: junos
  host: sjc-fw-01.net.arkadin.lan
region: noram
roles:
- firewall
type: network

interface_monitor:
  1:
    - ge-0/0/3
    - ge-9/0/3
    - ge-0/0/5
    - ge-9/0/5
