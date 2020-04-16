multi_snmpv3:
  netconfig.managed:
    - template_name: salt://network/general/multi/snmpv3/snmpv3.j2
    - snmpv3: {{ salt.pillar.get('snmpv3') }}
    - debug: true