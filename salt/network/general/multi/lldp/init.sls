lldp_configured:
  netconfig.managed:
    - template_name: salt://network/general/multi/lldp/lldp.j2
    - debug: true
