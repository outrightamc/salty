tcpmss_configured:
  netconfig.managed:
    - template_name: salt://network/general/juniper/tcpmss/tcpmss.j2
    - tcpmss: {{ salt.pillar.get('security:tcpmss') }}
    - debug: true
