{% if salt.grains.get('os_family') == "RedHat" %}
host_firewall_salt_service:
  firewalld.service:
    - name: salt-amqp
    - ports:
      - 4505/tcp
      - 4506/tcp

host_firewall_salt_zone:
  firewalld.present:
    - name: 00_salt
    - sources: {{ salt.pillar.get('salt_networks', []) }}
    - services:
      - salt-amqp
      - ssh
    - require:
      - firewalld: salt-amqp
{% endif %}
