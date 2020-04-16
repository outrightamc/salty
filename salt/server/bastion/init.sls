include:
  - server.base.local-users

set_timezone_utc:
  timezone.system:
    - name: UTC

{% set region = salt.grains.get('region', 'emea') %}
ntp_configured:
  pkg.installed:
    - name: openntpd
  file.managed:
    - name: /etc/openntpd/ntpd.conf
    - source: salt://server/bastion/ntpd.conf.j2
    - template: jinja
    - mode: 0644
    - user: root
    - group: root
    - servers: {{ salt.pillar.get('network_services:ntp') | json }}
  service.running:
    - name: openntpd
    - enable: true
    - watch:
      - file: /etc/openntpd/ntpd.conf

dns_configured:
  file.managed:
    - name: /etc/resolv.conf
    - source: salt://server/bastion/resolv.conf.j2
    - template: jinja
    - mode: 0644
    - user: root
    - group: root
    - servers: {{ salt.pillar.get('network_services:dns', {}).get(region, []) | json }}
