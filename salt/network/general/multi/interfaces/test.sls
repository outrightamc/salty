{% set compiled_config = salt.compile_services.merged_config() %}
interfaces_configured:
  file.managed:
    - name: /home/dturner/{{ grains.id }}_test/interfaces.conf
    - source: salt://network/interfaces/interfaces.j2
    - template: jinja
    - context:
        vlans: {{ compiled_config.get('vlan', []) | json }}
        instances: {{ compiled_config.get('routing_instances', []) | json }}
        interfaces: {{ compiled_config.get('interfaces', []) | json }}
