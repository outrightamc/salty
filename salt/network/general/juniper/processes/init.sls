juniper_processes:
  netconfig.managed:
      - template_name : salt://network/general/juniper/processes/processes.j2
      - processes: {{ salt.pillar.get('processes', {}) | json }}