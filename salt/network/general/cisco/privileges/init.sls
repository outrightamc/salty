privileges_configured:
  netconfig.managed:
    - template_name: salt://network/general/cisco/privileges/privileges.j2
    - privileges: {{ salt.pillar.get('privileges', {}) | json }}
    - debug: true