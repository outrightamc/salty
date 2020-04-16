#!jinja|yaml|gpg
peerings:
  - id: VRF_BRDSFT_SIP
    version: 2
    state: present
    description: Broadsoft BroadCloud Customers
    local: { device: carrier_sbc, network: 10.0.75.128/28, vlan: 3010, node_group: local_dev }
    routing:
      vrf: { allocation_type: unique, id: 3010 }
      bgp:
        asn: 21534
        password: |
          -----BEGIN PGP MESSAGE-----

          hQIMA7EyDH5sxwv4AQ//ebnky4FRgnBsu5qYglkr2jgYTtCus6SQNn+xhu5nS698
          BzTJUloyXcIewlfa0ERnbhvIriEjsIUP/SDxcJj771GocmY2MsdodxDMUabEUinZ
          0sf9W104GfWzS78619CPH11UP0+Z+V7iKjZn8EOaU6eYPSuVyzzbvotKAoCQsNvQ
          s9RItMOVOvhqowJnTqGwdAbHL/x4IGuatzm8WSCzxTPfzhB/knI8k5cSC5ynHhnw
          VAqeZBlk90DWyRA22dWUXysF5ZI2B9cJb+2Pg7WASTHuRzEOUHFhX6nC9DWYJWow
          H3ZNE+HNoA7SVcK/Fp2cqtFk2DBu9SR2G6N861rrKjzAKst5X4XT2R3Yo9DVDX4v
          kZEe+5eKBQZCjxLcrtzYAT7RD73b3B8nMR0jnVeUWpJM5UX5tLAgYe6A72SgLvxX
          vFQdCqw/Wkvnj6alAI1CUf5mPR7QS3TmI9SOQ4qevbB2IBhhTg/XokOE6ysqEZWn
          nJt0ad9rhTZ2Fi5Raf69/298cjOiw9ygUru9rwf0VJ3+ztPpHbufJxJkVXTicZj5
          e/idZ1zObJYLMoS0ME5DyqdMP4Nd7g4AU9e6eKjMBRIeaFh0XE1KBbrxZaCzrQZq
          vg2/nOz4o1Rg38qJkjk1mxFsLz8HBdkimazdju5gwqdWxrZuD+/Nm2Ng75alsvfS
          SwEogqF+H00OMvaaUO0Ao9j37SaOmJPLLnHLXfFMLaShKl56O5OVZ6NpMyyqidkb
          wCrrQ4jDeN/mEq9yNbcngxRpsILQOPu+hz1ptA==
          =Xyrh
          -----END PGP MESSAGE-----
        import_filter:
          - 199.59.67.0/25
    ix_group:
      - network: 10.0.75.0/29
        node_group: dual_rtr
        vlan: 3505
        reverse_ip: false
        preference: pyrixrt01
        bfd: true
        bandwidth: 50
        connection:
          - { switch: pyrixag01, port: GigabitEthernet1/1/4, circuit_id: ID_MISSING, tagged: true }
