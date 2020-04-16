aging_configured:
  netconfig.managed:
    - template_name: salt://network/general/cisco/aging/aging.j2
    - aging: {{ salt.pillar.get('aging') }}
    - debug: true