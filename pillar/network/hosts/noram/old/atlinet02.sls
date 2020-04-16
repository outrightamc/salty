#!jinja|yaml|gpg

proxy:
  host: atlinet02.net.arkadin.lan
  driver: junos
dc: atl
region: noram
type: network
roles:
  - core


# SNMPv3 custom pillar (ATLINET02 only)
snmpv3:
  snmp:
    view: 'fullmib'
    oids:
      - .1.3.6.1.2.1.2.2.1.10 #Interface IN octets
      - .1.3.6.1.2.1.2.2.1.16 #Interface OUT octets
      - .1.3.6.1.2.1.2.2.1.2 #Interface description
      - .1.3.6.1.2.1.2.2.1.5 #Interface speed
      - .1.3.6.1.2.1.2.2.1.7 #Interface admin state
      - .1.3.6.1.2.1.2.2.1.8 #Interface operational state
      - .1.3.6.1.2.1.31.1.1.1.1 #Interface name
      - .1.3.6.1.2.1.31.1.1.1.10 #Interface HC OUT octets
      - .1.3.6.1.2.1.31.1.1.1.15 #Interface High speed
      - .1.3.6.1.2.1.31.1.1.1.6 #Interface HC IN octets
      - .1.3.6.1.2.1.15.3.1.16 #BGP Peer FSM established time
      - .1.3.6.1.2.1.15.3.1.2 #BGP Peer state
      - .1.3.6.1.2.1.15.3.1.9 #BGP Peer remote AS
      - .1.3.6.1.2.1.15.6.1.6 #BGP Path Attr NextHop
      - .1.3.6.1.2.1.1.3.0 #Sys uptime

  notify:
    tag: 'TAG_NOCTION_ATL'
    name: 'NOCTION_SUPPORT'

  snmpcomm:
    secname: 'NOCTIONATL'
    name: 'SC_NOCTION1'
    commname: 'COMM_ARK_NOCTION'

  targetaddr:
    name: 'TA_NOCTION1'
    addr: 192.206.95.168
    netmask: 255.255.255.248
    port: 162
    param: 'TP_NOCTION1'

  usm:
    localengine:
      user: 'NOCTIONATL'
      authpass: |
        -----BEGIN PGP MESSAGE-----
        Version: GnuPG v2.0.22 (GNU/Linux)

        hQIMA7EyDH5sxwv4ARAAp8r6bAmHXVImT2LoZzETQlb3vxUJfHHvwOBvMH5pDCTz
        CJlOLaIUC61csnN5UabzOua+nSAhDrwr7HLHPTW2f0AjXqXwoVUdHnWQcCicO2+S
        cXTrHLbDvWlsj3Nji6cZIIcFc6l5qEqAMdjUNavzy6jBkqRs1c3PdXGdZGAq7R4M
        RbVyOYMIb4zRKB/U4cjhdQbLixpDSjGKtrOIDz2UoAedswLDuV/x/6pSrt0C6DDw
        JYfdBuSldfgZMaS1S8GQ3dB+0FV2IO5nz8PNClE9Zr0Qq6VxwuXaZ5HtQCE4mrEx
        UEz6plrkmdZ41eEsoN4llzXQuoJppkpmOktcf++WGyhHgdbsMvfldMjceyeRUDTH
        C4lGS10IqF/z+HzHs+bljVRYg5O4CKqiAMCzal+feJ5rDWezXq9jZybQHWcIWw4J
        TZpuecp4kMq5ChEKi30rN/Z/jB2Rdngl5ZEPzLNQk2QD0b/H73NRoNTlmf80SYxN
        RWHiZGn2nYV6xXLujjmxtMI4bYUtqVF1T4J2Ti/G1uyx2mMZsnNy60+xnAfTNhKG
        5kVfJBWD6t58fqZ163RDApUa3JUITCF6qWVr8QW+Fc29C6YVyKCZcC1E3zz349Z7
        ohiqVgnCmfqdmmo6203Lmq/VfVSgqzY06J+3dYm1NRFwcwzsdB2zjheMqQCEm43S
        SQH/TYM0mU+fZhxjzVyCpf3oyJpMkqesl82G+aYmXIpbrhYCkHL6LSj12aRjuiSK
        6tPB4TQVNELp8P0SbyJBQHsPgiRD40lKWyI=
        =a4hM
        -----END PGP MESSAGE-----
      privpass: |
        -----BEGIN PGP MESSAGE-----
        Version: GnuPG v2.0.22 (GNU/Linux)

        hQIMA7EyDH5sxwv4ARAAp8r6bAmHXVImT2LoZzETQlb3vxUJfHHvwOBvMH5pDCTz
        CJlOLaIUC61csnN5UabzOua+nSAhDrwr7HLHPTW2f0AjXqXwoVUdHnWQcCicO2+S
        cXTrHLbDvWlsj3Nji6cZIIcFc6l5qEqAMdjUNavzy6jBkqRs1c3PdXGdZGAq7R4M
        RbVyOYMIb4zRKB/U4cjhdQbLixpDSjGKtrOIDz2UoAedswLDuV/x/6pSrt0C6DDw
        JYfdBuSldfgZMaS1S8GQ3dB+0FV2IO5nz8PNClE9Zr0Qq6VxwuXaZ5HtQCE4mrEx
        UEz6plrkmdZ41eEsoN4llzXQuoJppkpmOktcf++WGyhHgdbsMvfldMjceyeRUDTH
        C4lGS10IqF/z+HzHs+bljVRYg5O4CKqiAMCzal+feJ5rDWezXq9jZybQHWcIWw4J
        TZpuecp4kMq5ChEKi30rN/Z/jB2Rdngl5ZEPzLNQk2QD0b/H73NRoNTlmf80SYxN
        RWHiZGn2nYV6xXLujjmxtMI4bYUtqVF1T4J2Ti/G1uyx2mMZsnNy60+xnAfTNhKG
        5kVfJBWD6t58fqZ163RDApUa3JUITCF6qWVr8QW+Fc29C6YVyKCZcC1E3zz349Z7
        ohiqVgnCmfqdmmo6203Lmq/VfVSgqzY06J+3dYm1NRFwcwzsdB2zjheMqQCEm43S
        SQH/TYM0mU+fZhxjzVyCpf3oyJpMkqesl82G+aYmXIpbrhYCkHL6LSj12aRjuiSK
        6tPB4TQVNELp8P0SbyJBQHsPgiRD40lKWyI=
        =a4hM
        -----END PGP MESSAGE-----

  vacm:
    group: 'AGVIEWALL'