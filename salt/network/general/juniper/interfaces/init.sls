juniper_interfaces:
  netconfig.managed:
      - template_name : salt://network/general/juniper/interfaces/interfaces.j2
      - interfaces: {{ salt.pillar.get('interfaces', {}) | json }}
      - rpm: {{ salt.pillar.get('rpm', {}) | json }} 
