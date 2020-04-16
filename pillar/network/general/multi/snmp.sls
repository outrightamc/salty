snmp:
  contact: nio@arkadin.com
  clients:
    - 10.105.137.56   # DETAUTLM01 DRP
    - 10.105.137.57   # DEPLZABPXY02 
    - 10.100.137.55   # USPATLLZBXVIP
    - 10.250.137.55   # HKPIFCLZBXVIP
    - 10.115.137.57   # FRPLZABPXYVIP
    - 10.100.19.21    # ATLNETUTIL01
    - 10.250.90.90    # netflow.arkadin.com
    - 192.206.95.169  # ATL IRP Noction VM
    - 10.105.137.80  # DEVICE42
  trap_groups:
    noram:
      default:
        noc_services:
          - 10.100.137.55
          - 10.100.19.21
    emea:
      ld4:
        noc_services:
          - 10.105.137.55
          - 10.100.19.21
      tau:
        noc_services:
          - 10.105.137.55
          - 10.100.19.21
      default:
        noc_services:
          - 10.115.137.55
          - 10.100.19.21
    apac:
      default:
        noc_services:
          - 10.250.137.55
          - 10.100.19.21
  community:
    network_services:
      mode: ro
    noc_services:
      mode: ro
