multi_ntp:
  netconfig.managed:
    - template_name: salt://network/general/multi/ntp/ntp.j2
    - ntp_servers: {{ salt.pillar.get('network_services:ntp') | json }}
    - source_address: {{ salt.netutil.management_int() | json }}
    - debug: true
