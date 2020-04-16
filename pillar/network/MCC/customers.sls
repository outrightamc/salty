#https://myarkadin.sharepoint.com/:u:/t/Network_Infra_Ops/EYiITGMi2elJozveDNhZ83EBM_2pa1DWT1-_vj24mdgGMw?e=KjXRyb

# PHYSICAL UPLINKS CONFIGURATION
mcc_edge_interfaces:
 - minion: atlixag01
   uplink: GigabitEthernet2/2
   description: MCC:Virtela:PP5-6:PP:0203-180907:NTTID-20986368
   vlans: 2601-2602
   nonegotiate: True

 - minion: atlixag02
   uplink: GigabitEthernet4/5
   description: MCC:Virtela:PP13-14:PP:0207-1026788:NTTID-20986366
   vlans: 2601-2602

# LOOPBACK DEFINITION
mcc_rd_loopbacks: {atlixrt01: 172.16.0.17, atlixrt02: 172.16.0.18}

# ROUTE-MAP CONFIGURATION
mcc_ixrt_lp:
  IM: [ atlixrt01 ]
  EX: [ atlixrt02 ]
  increase_lp: [ atlixrt01 ]
  increased_lp: 200

# VLANS CONFIGURATION
# VLAN ID EXTERNAL 2601-2699
# VLAND ID INTERNAL 3101-3199
mcc_edge_vlans:
 - local_minions: [ atlixag01, atlixag02 ]
   vlan_ids: 
   - { vlan_id: 2601, name: VL_ATL_2601_MCC_106-EXT }
   - { vlan_id: 3101, name: VL_ATL_3101_MCC_106-LAN }
   - { vlan_id: 2602, name: VL_ATL_2602_MCC_108-EXT }
   - { vlan_id: 3102, name: VL_ATL_3102_MCC_108-LAN }

# VRF IDs, VRF NAME = VRF_MCC_VRFID https://device42.arkadin.lan/admin/rackraj/vrfgroup/
mcc_ixrt_vrfs:
 - local_minions: [ atlixrt01, atlixrt02 ]
   vrf_ids: [ 106, 108 ]

# POLICER ARE DEFINED WITHIN THE JINJA2 TEMPLATE

# SUBINTERFACE CONFIGURATION
mcc_ixrt_interfaces:
#-------------------------------COPY TEMPLATE EX VLAN ID 2601----------------------------------
# VLAN 2601 ATL INTERFACES
 - minion: atlixrt01
   wan_phy_itf: GigabitEthernet0/0/2
   wan_vlan_id: 2601
   wan_ip: { ip: 172.16.14.34, mask: 255.255.255.252 }
   wan_description: E_CUST_MCC_106:KM60004:W190000612
   policer: POLICER_20M
   lan_phy_itf: GigabitEthernet0/0/1
   lan_vlan_id: 3101
   lan_ip: { ip: 192.168.1.2, mask: 255.255.255.248 }
   lan_description: V:192.168.1.0/29:MCC_106:LAN
   hsrp: { priority: 200, standby: 192.168.1.1, preempt: True} 
   vrf_id: 106
   bandwidth: 20000
 - minion: atlixrt02
   wan_phy_itf: GigabitEthernet0/0/2
   wan_vlan_id: 2601
   wan_ip: { ip: 172.16.14.38, mask: 255.255.255.252 }
   wan_description: E_CUST_MCC_106:KM60005:W190000613
   policer: POLICER_20M   
   lan_phy_itf: GigabitEthernet0/0/1
   lan_vlan_id: 3101
   lan_ip: { ip: 192.168.1.3, mask: 255.255.255.248 }
   lan_description: V:192.168.1.0/29:MCC_106:LAN
   hsrp: { standby: 192.168.1.1} 
   vrf_id: 106
   bandwidth: 20000
#---------------------------------------------------------------------------------------------
# VLAN 2602 ATL INTERFACES
 - minion: atlixrt01
   wan_phy_itf: GigabitEthernet0/0/2
   wan_vlan_id: 2602
   wan_ip: { ip: 172.16.14.42, mask: 255.255.255.252 }
   wan_description: E_CUST_MCC_108:KM60006:W190000614
   policer: POLICER_30M
   lan_phy_itf: GigabitEthernet0/0/1
   lan_vlan_id: 3102
   lan_ip: { ip: 192.168.1.2, mask: 255.255.255.248 }
   lan_description: V:192.168.1.0/29:MCC_108:LAN
   hsrp: { priority: 200, standby: 192.168.1.1, preempt: True} 
   vrf_id: 108
   bandwidth: 30000
 - minion: atlixrt02
   wan_phy_itf: GigabitEthernet0/0/2
   wan_vlan_id: 2602
   wan_ip: { ip: 172.16.14.46, mask: 255.255.255.252 }
   wan_description: E_CUST_MCC_108:KM60007:W190000615
   policer: POLICER_30M
   lan_phy_itf: GigabitEthernet0/0/1
   lan_vlan_id: 3102
   lan_ip: { ip: 192.168.1.3, mask: 255.255.255.248 }
   lan_description: V:192.168.1.0/29:MCC_108:LAN
   hsrp: { standby: 192.168.1.1} 
   vrf_id: 108
   bandwidth: 30000

# BGP CONFIGURATION
mcc_ixrt_bgp:
#-------------------------------COPY TEMPLATE EX VLAN ID 2601----------------------------------
# VLAN 2601 ATL BGP
- minion: atlixrt01
  vrf_id: 106
  lan_network : { network: 192.168.1.0, mask: 255.255.255.248 }
  neighbor: 172.16.14.33
  maxprefix: 50
  local_preference: 200
  route_map: { name: IM_MCC_V4, direction: in}
- minion: atlixrt02
  vrf_id: 106
  lan_network : { network: 192.168.1.0, mask: 255.255.255.248 }
  neighbor: 172.16.14.37
  maxprefix: 50
  route_map: { name: EX_MCC_V4, direction: out}  
#---------------------------------------------------------------------------------------------
# VLAN 2602 ATL BGP
- minion: atlixrt01
  vrf_id: 108
  lan_network : { network: 192.168.1.0, mask: 255.255.255.248 }
  neighbor: 172.16.14.41
  maxprefix: 50
  local_preference: 200
  route_map: { name: IM_MCC_V4, direction: in}
- minion: atlixrt02
  vrf_id: 108
  lan_network : { network: 192.168.1.0, mask: 255.255.255.248 }
  neighbor: 172.16.14.45
  maxprefix: 50
  route_map: { name: EX_MCC_V4, direction: out}  