#!jinja|yaml|gpg

snmpv3:
  snmp:
    view: 'fullmib'

  notify:
    tag: 'TAG_NOCTION_XXX'
    name: 'NOCTION_SUPPORT'

  notificafil:
    name: 'NF_TRAPS_ALL'

  snmpcomm:
    secname: 'NOCTIONXXX'
    name: 'SC_NOCTION1'
    commname: 'COMM_ARK_NOCTION'

  targetaddr:
    name: 'TA_NOCTION1'
    addr: 192.206.95.168
    netmask: 255.255.255.248
    port: 162
    param: 'TP_NOCTION1'

  targetparam:
    name: 'NOCTIONXXXUSM'

  usm:
    localengine:
      user: 'NOCTIONXXX'
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