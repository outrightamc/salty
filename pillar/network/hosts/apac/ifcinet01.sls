#!jinja|yaml|gpg

proxy:
  host: ifcinet01.net.arkadin.lan
  driver: junos
dc: ifc
region: apac
type: network

noction_snmp:
  clients:
    - 103.214.228.112/29  # NOCTION
  community:
    noction:
      mode: ro

# SNMPv3 custom pillar (IFCINET01 only)
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
    tag: 'TAG_NOCTION_IFC'
    name: 'NOCTION_SUPPORT'

  snmpcomm:
    secname: 'NOCTIONIFC'
    name: 'SC_NOCTION1'
    commname: 'COMM_ARK_NOCTION'

  targetaddr:
    name: 'TA_NOCTION1'
    addr: 103.214.228.112
    netmask: 255.255.255.248
    port: 162
    param: 'TP_NOCTION1'

  usm:
    localengine:
      user: 'NOCTIONIFC'
      authpass: |
        -----BEGIN PGP MESSAGE-----
        Version: GnuPG v2.0.22 (GNU/Linux)

        hQIMA7EyDH5sxwv4AQ/+M10h5yt5OxeLtbMug6T3A5gIO3UMW8bG09sj7nPpI6No
        nNIW2iYx8MCf4xC+V7FH13MCRZfzrcpSFcfOhrcKI5bv+RE9w4FNcEta6y6gL94E
        49qvI4GvZydr2r02Jllw8aLwL+iYWUdctCBovy5fWJKG7f0Eg9NZu4z+d3w8fjBp
        oMMvC+M+OTj7cTz1H/3e8fd5CYeyyRSSPdMWAGkzb9Nj7xci724H7/ARDxBqHo9l
        0vSX/7oEYnF1cXBZ9IkToFqWyaUGuKxeejWbrSJ3bzyIhx18T+v9rcjH+WlE+Xf7
        7qe5AsWxbRYLEaYsB6+OHllScGYlYuJ0s+HVMhe7llzkHIh7t4xEzqf7TKuZhG6y
        6YpY9gaWFL6QxXGd5JDB4trNyu1O1PDDlXC8Z+0yFkN8NL1PhURtXGBXjex6Ce4j
        PoiODg2mX9k0Sdw7Rjw7095qgP6XxGDBR2hPYnmRMqcaxq27gxZY+oPvUVsOexB/
        ISMCWjXm7DbrBvoHmesMMIKgpaBp6ZSjskjS0UMCZ9hyowJ7aBFFoPq+nznjBkAj
        VIiwK6N6hd3UU2dhvt9QPurD4PfCQAH7XMJ4ZHqKdAj9J+RI1LGS+95/TtIQ9XXp
        Fts1+YPCbC4zKmauhCHg4CzOukDxVfZ+0z16pdzLJ1hnokV6k4NLuOw0FeUHYKXS
        SQHNrltrhdlMDtI6YrUHSxlw8ukFASAKgNtL+scnMhVTx0xzV4CSc0Ubb8WldX6Y
        J8rKYEESX8JVUJ5P4uv79VwG5sQ9VUy0Ark=
        =2iup
        -----END PGP MESSAGE-----
      privpass: |
        -----BEGIN PGP MESSAGE-----
        Version: GnuPG v2.0.22 (GNU/Linux)

        hQIMA7EyDH5sxwv4AQ/+M10h5yt5OxeLtbMug6T3A5gIO3UMW8bG09sj7nPpI6No
        nNIW2iYx8MCf4xC+V7FH13MCRZfzrcpSFcfOhrcKI5bv+RE9w4FNcEta6y6gL94E
        49qvI4GvZydr2r02Jllw8aLwL+iYWUdctCBovy5fWJKG7f0Eg9NZu4z+d3w8fjBp
        oMMvC+M+OTj7cTz1H/3e8fd5CYeyyRSSPdMWAGkzb9Nj7xci724H7/ARDxBqHo9l
        0vSX/7oEYnF1cXBZ9IkToFqWyaUGuKxeejWbrSJ3bzyIhx18T+v9rcjH+WlE+Xf7
        7qe5AsWxbRYLEaYsB6+OHllScGYlYuJ0s+HVMhe7llzkHIh7t4xEzqf7TKuZhG6y
        6YpY9gaWFL6QxXGd5JDB4trNyu1O1PDDlXC8Z+0yFkN8NL1PhURtXGBXjex6Ce4j
        PoiODg2mX9k0Sdw7Rjw7095qgP6XxGDBR2hPYnmRMqcaxq27gxZY+oPvUVsOexB/
        ISMCWjXm7DbrBvoHmesMMIKgpaBp6ZSjskjS0UMCZ9hyowJ7aBFFoPq+nznjBkAj
        VIiwK6N6hd3UU2dhvt9QPurD4PfCQAH7XMJ4ZHqKdAj9J+RI1LGS+95/TtIQ9XXp
        Fts1+YPCbC4zKmauhCHg4CzOukDxVfZ+0z16pdzLJ1hnokV6k4NLuOw0FeUHYKXS
        SQHNrltrhdlMDtI6YrUHSxlw8ukFASAKgNtL+scnMhVTx0xzV4CSc0Ubb8WldX6Y
        J8rKYEESX8JVUJ5P4uv79VwG5sQ9VUy0Ark=
        =2iup
        -----END PGP MESSAGE-----

  vacm:
    group: 'AGVIEWALL'