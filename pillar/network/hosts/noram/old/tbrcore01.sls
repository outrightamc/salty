#!jinja|yaml|gpg
dc: tbr
proxy:
  driver: ios
  host: tbrcore01.net.arkadin.lan
  always_alive: false
  username: netops
  passwd: |
    -----BEGIN PGP MESSAGE-----

    hQIMA7EyDH5sxwv4AQ//fTYAUlraBQSuXUCGcooHYki1C8LArE+bsZKvzszAMTJF
    eZcreh1A8gtdSa+xqHDtdGx2Cou6IzqqlbxgBHokebYuaKLG/hPH6ETJSdi+QpZ6
    dkG/gaUwlYHZLpBDA0EY6rNPuIGb/d2ZSf6aojMTl118ziBR8pGAMq0GVxQzAJv3
    hxEqnUc6dy/ednKsREALRXMnJ/xAJtICBVm/fX00T9bc9xEYQfbt0uqrghcb+XXr
    MipLrf2rb6aVl+VV3s8B47l2GREEs0UcIVk0TXdVNTk9Dv6Q/Pe8Twj2Fe4q42oo
    dJbnxPaAJx9d+1578EU6MAJYiHm6XPHD8Q56pZS+X8dmElNdPb9olEBL6i+imiVc
    ubfnJ+3MrAQ59uyAjv2Rs68aM7eHTyKmVj4/sX+504QxUtpWI18Gkg0MR4kWZM/g
    UB7+0NxE9NOtESI79Q1kDuWN2x94TyvgSmwrX4Rwc1SZqkpUxn8aEkfh3d8yY1N9
    G1g5xZiNzsC85dS+/+11JhptXEJk2AUr4pq43oVhIdYKGlpDk1BTB2Q55QGgXDmq
    Fxkwfnq0/oHsGy4jfg5XQqSGTSQW8PtG117fDwvjJ8R8Gen8qnuQIHWaTzeKETOU
    Az6GVDkiLomohe/DtPS1VU7nsTQ/HBc3Tu3vvL22W5qLoyIF+G+OKhfN/9K9tTDS
    SwELgdop5kLMP1zIq4Zbuggh7436woLEoGKM9BJXMbtiKW3PKLBm1Okrg63SCoJM
    F7Fn3Whp2uP0zEyizKlFUDSB/m7TERiepWS0Sg==
    =f2ow
    -----END PGP MESSAGE-----
  optional_args:
    transport: telnet
    global_delay_factor: 2
region: noram
type: network
roles: [core_switch]
