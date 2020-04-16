{% set compiled_config = salt.compile_services.merged_config() %}
policy_configured:
  netconfig.managed:
    - template_name: salt://network/general/multi/policy-options/policy.j2
    - {{ compiled_config.get('policy_options', {}) | json }}
