aliases_configured:
  netconfig.managed:
    - template_name: salt://network/general/cisco/aliases/aliases.j2
    - aliases: {{ salt.pillar.get('aliases', {}) | json }}
    - debug: true