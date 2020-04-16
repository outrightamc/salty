/etc/salt/proxy:
  file.managed:
    - source: salt://server/salt/proxy.conf
    - user: root
    - group: root
    - mode: 644

{% set proxy_minions = salt.pillar.get('minion_controller_map')[grains.id] %}
{% if grains.init == 'systemd' %}
/etc/systemd/system/salt-proxy@.service:
  file.managed:
    - source: salt://server/salt/salt-proxy.service
    - user: root
    - group: root
    - mode: 644
  {% for m in proxy_minions %}
{{ m }}_proxy_minion:
  service.running:
    - name: salt-proxy@{{ m }}
    - enable: true
    - watch:
      - file: /etc/salt/proxy
  {% endfor %}
{% else %}
  {% for m in proxy_minions %}
{{ m }}_proxy_minion:
  salt_proxy.configure_proxy:
    - proxyname: {{ m }}
    - start: true
    - watch:
      - file: /etc/salt/proxy
  {% endfor %}
{% endif %}
