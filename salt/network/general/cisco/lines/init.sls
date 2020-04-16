lines_configured:
  netconfig.managed:
    - template_name: salt://network/general/cisco/lines/lines.j2
    - lines: {{ salt.pillar.get('lines', {}) | json }}
    - debug: true