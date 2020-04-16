juniper_interface_monitor:
  netconfig.managed:
    - template_name: salt://network/general/juniper/interface_monitor/interface_monitor.j2
    - interface_monitor: {{ salt.pillar.get('interface_monitor', []) | json }}
