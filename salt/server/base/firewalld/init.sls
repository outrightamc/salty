host_firewall_running:
  pkg.installed:
    - name: firewalld
  service.running:
    - name: firewalld
    - enable: true

host_firewall_internal_zone:
  firewalld.present:
    - name: internal
    - sources:
      - 10.0.0.0/8
      - 172.16.0.0/12
      - 192.168.0.0/16 
    - services: {{ salt.pillar.get('firewall:services', ['ssh']) }}
    - ports: {{ salt.pillar.get('firewall:ports') }}
    - require:
      - service: firewalld

host_firewall_public_zone:
  firewalld.present:
    - name: public
    - services: []
    - ports: []
    - sources: []
    - default: true
    - require:
      - service: firewalld
