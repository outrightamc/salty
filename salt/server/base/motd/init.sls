install_figlet:
  pkg.installed:
    - name: figlet

{% if grains['os'] == 'Ubuntu' %}

install_update-motd:
  pkg.installed:
    - name: update-motd

motd_configured:
  file.managed:
    - name: /etc/update-motd.d/00-header
    - source: salt://server/base/motd/00-header
    - template: jinja
    - mode: 0655
    - user: root
    - group: root
    - require:
      - pkg: update-motd

remove_help:
  file.absent:
    - name: /etc/update-motd.d/10-help-text
    - require:
      - pkg: update-motd

remove_news:   
  file.absent:
    - name: /etc/update-motd.d/50-motd-news
    - require:
      - pkg: update-motd

remove_release:   
  file.absent:
    - name: /etc/update-motd.d/91-release-upgrade
    - require:
      - pkg: update-motd

{% elif grains['os'] == 'CentOS' or grains['os'] == 'Raspbian' %}

motd_login_info:
  file.managed:
    - name: /etc/profile.d/login-info.sh
    - source: salt://server/base/motd/login-info.sh
    - template: jinja
    - mode: 0655
    - user: root
    - group: root

remove_motd:
  file.absent:
    - name: /etc/motd

{% endif %}