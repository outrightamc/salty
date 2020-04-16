mcc_configured:
  netconfig.managed:
    - template_name: salt://network/MCC/customer.j2
    - mcc_edge_interfaces: {{ salt.pillar.get('mcc_edge_interfaces', {}) | json }}
    - mcc_edge_vlans: {{ salt.pillar.get('mcc_edge_vlans', {}) | json }}
    - mcc_ixrt_vrfs: {{ salt.pillar.get('mcc_ixrt_vrfs', {}) | json }}    
    - mcc_rd_loopbacks: {{ salt.pillar.get('mcc_rd_loopbacks', {}) | json }}   
    - mcc_ixrt_interfaces: {{ salt.pillar.get('mcc_ixrt_interfaces', {}) | json }}
    - mcc_ixrt_bgp: {{ salt.pillar.get('mcc_ixrt_bgp', {}) | json }}
    - mcc_ixrt_lp: {{ salt.pillar.get('mcc_ixrt_lp', {}) | json }}    
    - debug: true