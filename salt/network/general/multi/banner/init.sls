banner_configured:
  netconfig.managed:
    - template_name: salt://network/general/multi/banner/banner.j2
    - motd_banner: {{ salt.pillar.get('motd', []) | json }}
