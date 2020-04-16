{%- set region = salt.pillar.get('region') -%}

multi_syslog_:
  netconfig.managed:
    - template_name: salt://network/general/multi/syslog/syslog.j2
    - syslog_servers: {{ salt.pillar.get('network_services:syslog:hosts', {}).get(region, []) | json }}
    - facility: {{ salt.pillar.get('network_services:syslog:facility') }}
    - severity: {{ salt.pillar.get('network_services:syslog:severity') }}
    - junos_severity: {{ salt.pillar.get('network_services:syslog:junos_severity') }}    
    - severity_level: {{ salt.pillar.get('network_services:syslog:severity_level') }}    
    - buffer: {{ salt.pillar.get('network_services:syslog:buffer') }}
    - outputs: {{ salt.pillar.get('network_services:syslog:outputs', {}) | json }}
    - source_address: {{ salt.netutil.management_int() | json }}
    - debug: true
