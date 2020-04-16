{% set compiled_config = salt.compile_services.merged_config() %}
instances_configured:
  netconfig.managed:
    - template_name: salt://network/general/multi/routing-instances/instances.j2
    - instances: {{ compiled_config.get('routing_instances', {}) | json }}
    - routing_options: {{ compiled_config.get('routing_options', {}) | json }}
