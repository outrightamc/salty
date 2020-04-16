multi_snmp:
  netconfig.managed:
    - template_name: salt://network/general/multi/snmp/snmp.j2
    - snmp: {{ salt.pillar.get('snmp') }}
    - noction_snmp: {{ salt.pillar.get('noction_snmp') }}
    - snmpv3: {{ salt.pillar.get('snmpv3') }}    
    - region: {{ salt.pillar.get('region') }}
    - dc: {{ salt.pillar.get('dc', 'unknown') }}
    - source_address: {{ salt.netutil.management_int() | json }}
    - debug: true
