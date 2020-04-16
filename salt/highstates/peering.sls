base:
  # peering states
  'ld4ixrt*':
    - network.general.multi.interfaces
    - network.general.multi.policy-options
    - network.general.multi.routing-instances
  'ld4ixag* or ld4-ce-*':
    - network.general.multi.vlans
    - network.general.multi.interfaces

  'tauixrt*':
    - network.general.multi.interfaces
    - network.general.multi.policy-options
    - network.general.multi.routing-instances
  'tauixag*':
    - network.general.multi.vlans
    - network.general.multi.interfaces

  'shiixrt*':
    - network.general.multi.interfaces
    - network.general.multi.policy-options
    - network.general.multi.routing-instances
  'shiixag*':
    - network.general.multi.vlans
    - network.general.multi.interfaces
  'shi-ce-*':
    - network.general.multi.vlans

  'pyrixrt*':
    - network.general.multi.interfaces
    - network.general.multi.policy-options
    - network.general.multi.routing-instances
  'pyrixag*':
    - network.general.multi.vlans
    - network.general.multi.interfaces