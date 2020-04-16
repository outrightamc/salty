include:
  - network.general.cumulus.base.local-users

{% set region = salt.pillar.get('region', 'emea') %}

set_timezone_utc:
  timezone.system:
    - name: UTC

ntp_configured:
  file.managed:
    - name: /etc/ntp.conf
    - source: salt://network/general/cumulus/base/ntp.conf.j2
    - template: jinja
    - mode: 0644
    - user: root
    - group: root
    - show_changes: true
    - context:
        servers: {{ salt.pillar.get('network_services:ntp') | json }}
        source_ip: {{ salt.pillar.get('loopback', False) }}
  service.running:
    - name: ntp
    - enable: true
    - watch:
      - file: /etc/ntp.conf

snmpd_configured:
  file.managed:
    - name: /etc/snmp/snmpd.conf
    - source: salt://network/general/cumulus/base/snmpd.conf.j2
    - template: jinja
    - mode: 0600
    - user: root
    - group: root
    - show_changes: true
    - context:
        sysname: {{ grains.id }}
        snmp: {{ salt.pillar.get('snmp') }}
        region: {{ salt.pillar.get('region') }}
        dc: {{ salt.pillar.get('dc', 'unknown') }}
        listening_address: {{ salt.pillar.get('loopback', False) }}
  service.running:
    - name: snmpd
    - enable: true
    - watch:
      - file: /etc/snmp/snmpd.conf

dns_configured:
  file.managed:
    - name: /etc/resolv.conf
    - source: salt://server/base/resolv.conf.j2
    - template: jinja
    - mode: 0644
    - user: root
    - group: root
    - show_changes: true
    - context:
        servers: {{ salt.pillar.get('network_services:dns', {}).get(region, []) | json }}

banner_configured:
  file.managed:
    - name: /etc/motd
    - contents_pillar: motd

syslog_configured:
  file.managed:
    - name: /etc/rsyslog.d/11-remotesyslog.conf
    - source: salt://network/general/cumulus/base/syslog.conf.j2
    - template: jinja
    - mode: 644
    - user: root
    - group: root
    - context:
        syslog_servers: {{ salt.pillar.get('network_services:syslog:hosts', {}).get(region, []) | json }}
  service.running:
    - name: rsyslog
    - enable: true
    - watch:
      - file: /etc/rsyslog.d/11-remotesyslog.conf

firewall_configured:
  file.managed:
    - name: /etc/cumulus/acl/policy.d/10_oam.rules
    - source: salt://network/general/cumulus/base/oam_firewall.rules.j2
    - template: jinja
    - mode: 644
    - user: root
    - group: root
    - context:
        mgmt_nets: {{ pillar.management_nets }}
  cmd.run:
    - name: /usr/cumulus/bin/cl-acltool -i
    - onchanges:
      - file: /etc/cumulus/acl/policy.d/10_oam.rules
