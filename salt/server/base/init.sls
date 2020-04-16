include:
  - server.base.local-users
  - server.base.firewalld

set_timezone_utc:
  timezone.system:
    - name: UTC

{% set region = salt.grains.get('region', 'emea') %}
ntp_configured:
  # the package name is probably platform specific. we might need a grains.filter_by if we want debian in the future.
  pkg.installed:
    - name: ntp
  file.managed:
    - name: /etc/ntp.conf
    - source: salt://server/base/ntp/ntp.conf.j2
    - template: jinja
    - mode: 0644
    - user: root
    - group: root
    - servers: {{ salt.pillar.get('network_services:ntp') | json }}
  service.running:
    - name: ntpd
    - enable: true
    - watch:
      - file: /etc/ntp.conf

snmpd_configured:
  pkg.installed:
    - name: net-snmp
  file.managed:
    - name: /etc/snmp/snmpd.conf
    - source: salt://server/base/snmp/snmpd.conf.j2
    - template: jinja
    - mode: 0644
    - user: root
    - group: root
  service.running:
    - name: snmpd
    - enable: true
    - watch:
      - file: /etc/snmp/snmpd.conf

dns_configured:
  file.managed:
    - name: /etc/resolv.conf
    - source: salt://server/base/dns/resolv.conf.j2
    - template: jinja
    - mode: 0644
    - user: root
    - group: root
    - servers: {{ salt.pillar.get('network_services:dns', {}).get(region, []) | json }}
