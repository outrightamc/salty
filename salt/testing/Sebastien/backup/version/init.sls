juniper_version:
  netconfig.managed:
      - template_name : salt://network/general/juniper/version/version.j2
      #- version: {{ salt.pillar.get('version') }}