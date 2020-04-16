juniper_routing-instances:
  netconfig.managed:
      - template_name : salt://network/general/juniper/routing-instances/routing-instances.j2
      - routing_instances: {{ salt.pillar.get('routing_instances_vrf', {}) | json }}
      - inet_routers: {{ salt.pillar.get('protocols:INET', {}) | json }}
      - routing_options: {{ salt.pillar.get('routing_options', {}) | json }}
      - fabric_asn: {{ salt.pillar.get('fabric_asn') }}