routing_options_configured:
  file.managed:
    - name: /home/dturner/{{ grains.id }}_test/routing-options.conf
    - template: jinja
    - source: salt://network/testing/routing-options/routing-options.j2
    - context: {{ pillar.static.routing_options | json }}
