install_rsyslog:
  pkg.installed:
    - name: rsyslog

rsyslog_remote_dir:
  file.directory:
    - name: /var/log/remote
    - user: root
    - group: wheel
    - dir_mode: 750
    - file_mode: 640

rsyslog_configured:
  file.managed:
    - name: /etc/rsyslog.d/remote.conf
    - source: salt://server/salt/rsyslog/rsyslog_remote.conf.j2
    - template: jinja
    - server: {{ salt.grains.get('fqdn_ip4')[0] }}

logrotate_configured:
  file.managed:
    - name: /etc/logrotate.d/rsyslog
    - source: salt://server/salt/rsyslog/rsyslog_rotate.conf

rsyslog_running:
  service.running:
    - name: rsyslog
    - enable: true
    - watch:
        - file: rsyslog_configured
