juniper_border_leaf_peering:
  netconfig.managed:
    - template_name: salt://network/general/juniper/bl-peering/bl-peering.j2
    - bl_loops: {{ salt.pillar.get('loopbacks:border_leaf') | json }}
    - loopback_ip: {{ salt.pillar.get('loopbacks:inet').get(grains.id) }}
