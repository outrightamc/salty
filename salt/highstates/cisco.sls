base:
  # ios only network minions
  '(G@os:ios or G@os:nxos*) and not I!@proxy!optional_args!transport:telnet':
    - network.general.multi.snmp
    - network.general.multi.ntp
    - network.general.multi.banner
    - network.general.multi.syslog

  'G@os:ios and not I!@proxy!optional_args!transport:telnet':  
    - network.general.cisco.privileges

  '(*core* or *ixag* or *accs*) and not I!@proxy!optional_args!transport:telnet':
    - network.general.cisco.aging

  # ios & nxos network minions
  '(G@os:ios or G@os:nxos*) and not I!@proxy!optional_args!transport:telnet':  
    - network.general.cisco.aliases
    - network.general.cisco.cdp
    - network.general.cisco.lines