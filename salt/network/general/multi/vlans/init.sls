{% set compiled_config = salt.compile_services.merged_config() %}
vlans_configured:
  netconfig.managed:
    - template_name: salt://network/general/multi/vlans/vlans.j2
    - debug: true
    - vlans: {{ compiled_config.get('vlan', []) | json }}
