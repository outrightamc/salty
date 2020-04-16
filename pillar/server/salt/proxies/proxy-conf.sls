#!jinja|yaml|gpg
proxy:
  proxytype: napalm
  optional_args:
    #http://napalm.readthedocs.io/en/latest/support/index.html#list-of-supported-optional-arguments
    ignore_warning: true # required for empty replace statements.
    global_delay_factor: 2
  username: go-svc-saltstack
  passwd: |
    -----BEGIN PGP MESSAGE-----
    Version: GnuPG v2.0.22 (GNU/Linux)

    hQIMA7EyDH5sxwv4AQ//W+qNsU2Vb8Qr3vCILrm0Rlw8B3GnuaKRtMfp3uoNLyfA
    cXj2FZG1QEXb0QzjvBrlSw9WefYF9XUs/6u/bLHMIKoCHGbGMdbESvA5J6F67ihA
    Uzunp7qsmiPo0sXsf0xejG+OYJsndM+oVAHCuoIMYSxg+BG0LqbMeJ11fA1pmq1Z
    RHz4zeftGCgsyqyNELxVS7lgJyUVwludvwXDNxHlVujk5XV0y044iJp5LZwQ1X2U
    xVj5w07xQG9lHqBV0a2jo6GGygSTlCYfVl9431gkjwPuj7leP4vECS5ChGubJhhr
    KgXBZV+4qUPG+6J0pUCJt4yglhHqTuQHJIfRzCOEbGMLNTQsjUepYg5pV/MKyKt4
    UGy85BuxSL1xbPXCGDXvmw5KrYqMZYiezMMl54jgTexWRpWcpnM+jwbhnpVMkQTg
    8XBR017HFkFBHFx71fQVQqqz70zjWnM+29CRNRrjL+s3vbPrk49eL/B2yGIoodC6
    beh3+8+rlXH8yyIRzYGTsw5e9seO8lirCVdLBDj1i2gyObgJOX+DcjTCTQonAZnG
    KnfsNM0dP8+/KZQoPmIMYmb97JBcRsbuXxqfPbcIku2PUZCE4eULukgJ5Yn7EUI0
    GMhVVUiPhUK0/GAJZngvsWFWo/VvDvucTARHQHO0BG536Knw/dwOoZQC4d7qke/S
    SwExqKjiga+MPV2QV1QSxDk7qdj6ODc3xT/1zxI9o/iMq8mpG6JDp1qlx/Jp9Ed+
    dbGDyC0PckS8alMFpG4xvTyeyyzWrL66859kJg==
    =MPC9
    -----END PGP MESSAGE-----
