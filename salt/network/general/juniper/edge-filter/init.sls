juniper_edge-filter:
  netconfig.managed:
    - template_name: salt://network/general/juniper/edge-filter/edge-filter.j2
    - martians: {{ salt.pillar.get('martians_ips', []) | json }}    
    - blacklisted: {{ salt.pillar.get('blacklisted_ips', []) | json }}
    - snmpallow: {{ salt.pillar.get('snmpallow_ips', []) | json }}
    - umbrella_ips: {{ salt.pillar.get('umbrella_ips', []) | json }}
