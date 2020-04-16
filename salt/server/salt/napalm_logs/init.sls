napalmlogs_configured:
  file.managed:
    - name: /etc/napalm/logs
    - source: salt://server/salt/napalm_logs/napalm-logs.j2
    - template: jinja
    - server: {{ salt.grains.get('fqdn_ip4')[0] }}

logrotate_configured:
  file.managed:
    - name: /etc/logrotate.d/napalm-logs
    - source: salt://server/salt/napalm_logs/napalm_rotate.conf