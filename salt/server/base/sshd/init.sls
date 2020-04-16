sshd_configured:
  pkg.installed:
    - name: openssh-server
  file.managed:
    - name: /etc/ssh/sshd_config
    - source: salt://server/base/sshd/sshd_config
    - template: jinja
    - mode: 0644
    - user: root
    - group: root
  service.running:
    - name: sshd
    - enable: true
    - watch:
      - file: /etc/ssh/sshd_config
