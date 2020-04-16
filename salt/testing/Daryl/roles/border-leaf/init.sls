border_leaf_role_protocols:
  file.managed:
    - name: /home/dturner/{{ grains.id }}_test/protocols.conf
    - template: jinja
    - source: salt://network/testing/roles/border-leaf/protocols.j2
    - context:
        loopback: {{ pillar.static.routing_options.router_id }}
        core: {{ pillar.core|json }}
        fabric: {{ pillar.fabric|json }}

border_leaf_role_chassis:
  file.managed:
    - name: /home/dturner/{{ grains.id }}_test/chassis.conf
    - template: jinja
    - source: salt://network/testing/roles/border-leaf/chassis.j2
