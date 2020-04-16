#ios
privileges:
  - traceroute
  - traceroute ip
  - ping  
  - ping ip
  - show users 
  - show version
  - show inventory  
  - show configuration
  - show processes history
  - show processes cpu
  - show interfaces
  - show interfaces description
  - show interfaces counters 
  - show standby brief
  - show processes memory
  - show arp
  - show log
  - show cdp neighbors
  - show lldp neighbors
  - show mac address-table
  - show vlan
  - show ip int
  - show ip int brief    
  - show ip route
  - show ip vrf
  - show ip bgp
  - show ip bgp summary
  - show ip bgp vpnv4 vrf
  - show ip bgp vpnv4 all
  - show ip bgp vpnv4 all summary
  - show ip ospf
  - show ip ospf neighbors
  - terminal length 0
  - terminal width 132
  - show environment

aliases:
  - name: u
    cmd: undebug all
  
  - name: siib  
    cmd: sh ip int brief

lines:
  sessiontimeout: 120
  exectimeout: 120 0
  logging: synchronous
  history: 256

aging: 14400
