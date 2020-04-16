dc: aub
proxy:
  driver: junos
  host: aub-fw-01.net.arkadin.lan
region: emea
roles: [firewall]
type: network

interface_monitor:
  1:
    - ge-0/0/0
    - ge-0/0/1
    - ge-0/0/2
    - ge-0/0/3
    - ge-0/0/4
    - ge-4/0/0
    - ge-4/0/1
    - ge-4/0/2
    - ge-4/0/3
    - ge-4/0/4
