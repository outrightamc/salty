base:
  # junos minions
  'G@os:junos and not I!@proxy!optional_args!transport:telnet':
    - network.general.multi.snmp
    - network.general.multi.ntp
    - network.general.multi.banner
    - network.general.multi.syslog

  # network local logins
  'chi-*':
    - network.general.juniper.login

  # edge routers
  '*inet*':
    - network.general.juniper.bl-peering
  '*-bl-* or *inet*':
    - network.general.juniper.edge-filter

  # Junos firewalls
  '*fw* and G@os:junos':
    - network.general.juniper.maxconfig
    - network.general.juniper.tcpmss
    - network.general.juniper.alg