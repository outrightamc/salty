base:
  # default
  '*':
    - sproxyhosts
    - sproxyconf

  # specific
  'router1':
    - network.hosts.noram.router1
  'vsrx1':
    - network.hosts.noram.vsrx1
  'mx1':
    - network.hosts.noram.mx1
  'vsrx2':
    - network.hosts.noram.vsrx2