{% set compiled_config = salt.compile_services.merged_config() %}
interfaces_configured:
  netconfig.managed:
    - template_name: salt://network/general/multi/interfaces/interfaces.j2
    - vlans: {{ compiled_config.get('vlan', []) | json }}
    - instances: {{ compiled_config.get('routing_instances', []) | json }}
    - interfaces: {{ compiled_config.get('interface', []) | json }}
    - debug: true
