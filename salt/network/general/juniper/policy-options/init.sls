juniper_policy-options:
  netconfig.managed:
      - template_name : salt://network/general/juniper/policy-options/policy-options.j2
      - policy_options: {{ salt.pillar.get('policy_options', {}) | json }}
