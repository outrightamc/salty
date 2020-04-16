juniper_protocols:
  netconfig.managed:
      - template_name : salt://network/general/juniper/protocols/protocols.j2
      - protocols: {{ salt.pillar.get('protocols', {}) | json }}
      - routing_options: {{ salt.pillar.get('routing_options', {}) | json }}