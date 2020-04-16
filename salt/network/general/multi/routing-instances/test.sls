{% set compiled_config = salt.compile_services.merged_config() %}
instances_configured:
  file.managed:
    - name: /home/dturner/{{ grains.id }}_test/instances.conf
    - source: salt://network/routing-instances/instances.j2
    - template: jinja
    - instances: {{ compiled_config.get('routing_instances', {}) | json }}
    - routing_options: {{ compiled_config.get('routing_options', {}) | json }}
