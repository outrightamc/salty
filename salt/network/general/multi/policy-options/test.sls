{% set compiled_config = salt.compile_services.merged_config() %}
policy_configured:
  file.managed:
    - name: /home/dturner/{{ grains.id }}_test/policy_options.conf
    - source: salt://network/policy-options/policy.j2
    - template: jinja
    - {{ compiled_config.get('policy_options', {}) | json }}
