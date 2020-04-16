juniper_login:
  netconfig.managed:
    - template_name: salt://network/general/juniper/login/login.j2
    - local_users: {{ salt.pillar.get('local_users', {}) | json }}
    - motd_banner: {{ salt.pillar.get('motd', []) | json }}
    - debug: True
