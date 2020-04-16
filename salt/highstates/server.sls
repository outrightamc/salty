base:
  # server minions
  '*-sltmst-* or *-sltprx-*':
    - server.base
    - server.base.motd
  '*-sltmst-*':
    - server.salt.firewall
  '*-sltprx-*':
    - server.salt.proxy
    - server.salt.rsyslog
    - server.salt.custom-napalm
  'atlrancid01 or atlnetutil01':
    - server.base.local-users
    - server.base.motd    
    - server.base.snmp