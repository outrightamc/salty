juniper_routing-options:
  netconfig.managed:
      - template_name : salt://network/general/juniper/routing-options/routing-options.j2
      - routing_options: {{ salt.pillar.get('routing_options', {}) | json }}