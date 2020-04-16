snmpd_configured:
  pkg.installed:
    - name: snmpd
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