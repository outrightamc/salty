#global
motd: |
    ====================================================================
    =         UNAUTHORIZED ACCESS TO THIS DEVICE IS PROHIBITED         =
    =    You must have explicit, authorized permission to access or    =
    =   configure this device. Unauthorized attempts and actions to    =
    =   access or use this system may result in civil and/or criminal  =
    = All activities performed on this device are logged and monitored =
    ====================================================================

msteams_hook_url: https://outlook.office.com/webhook/98fb1237-76f2-4e84-8a71-395d9ca4e714@2596d791-95a9-4f15-97b6-bfb8760e0ac4/IncomingWebhook/e74c7180a6184932a80fca52cd03e31c/df57b74c-0543-48ff-8470-4d194086c845
# regional network services
network_services:
  radius:
    - 10.115.38.110 # pa2nps01
    - 10.100.92.1 # chinps01

  syslog:
    facility: local5
    severity: informational
    severity_level: 6 # informational    
    buffer: 128000
    outputs:
      - buffered
      - console
      - monitor
      - trap
    junos_severity: notice
    hosts:
      noram:
        - 10.100.137.89 # atl-sltprx-01
        - 10.100.137.24  # USPATLLELKLOG01
        #- 10.126.4.50  # FRDLELKLOG01        
      emea:
        - 10.115.137.89 # pa2-sltprx-01
        - 10.124.23.24  # FRPLELKLOG01
        #- 10.126.4.50  # FRDLELKLOG01
      apac:
        - 10.250.137.89 # ifc-sltprx-01
        - 10.250.137.24  # HKPLELKLOG01
        #- 10.126.4.50  # FRDLELKLOG01       

  ntp:
    - 10.115.131.1
    - 10.115.131.2
    - 10.125.19.1
    - 10.125.19.2

  dns:
    noram:
      - 10.124.23.53  # pa2dns01
      - 10.100.51.1   # uschidc01
      - 10.122.97.1   # usat1dc01
    emea:
      - 10.124.23.53  # pa2dns01
      - 10.115.131.1  # frpa2dc02
      - 10.124.19.1   # frpa2dc04
    apac:
      - 10.124.23.53  # pa2dns01
      - 10.249.38.1   # jpshidc01
      - 10.250.137.1  # hkifcdc01

management_nets:
  - 10.0.1.0/24         # bastions
  - 10.100.19.20/32     # rancid
  - 10.100.19.21/32     # atlnetutil01
  - 10.100.137.89/32    # salt-proxy
  - 10.115.137.89/32    # salt-proxy
  - 10.250.137.89/32    # salt-proxy
  - 10.245.2.0/24
  - 172.29.0.0/16
  - 172.30.0.0/16
