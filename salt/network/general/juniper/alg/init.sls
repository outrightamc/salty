juniper_alg:
  netconfig.managed:
    - template_name: salt://network/general/juniper/alg/alg.j2
    - algs: {{ salt.pillar.get('security:algs', []) | json }}
    - debug: True