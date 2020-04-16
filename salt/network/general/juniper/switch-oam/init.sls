switch_oam:
  netconfig.managed:
      - template_name : salt://network/general/juniper/switch-oam/oam.j2
      - mgmt_nets: {{ salt.pillar.get('management_nets', []) | json }} 
