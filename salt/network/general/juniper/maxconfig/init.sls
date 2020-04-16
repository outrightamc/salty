maxconfig_configured:
  netconfig.managed:
    - template_name: salt://network/general/juniper/maxconfig/maxconfig.j2
    - maxconfig: {{ salt.pillar.get('junos') }}
