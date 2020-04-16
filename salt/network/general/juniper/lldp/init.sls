juniper_lldp:
  netconfig.managed:
    - template_name: salt://network/general/juniper/lldp/lldp.j2
    - debug: true
