#!jinja|yaml|gpg
dc: ld4
proxy:
  driver: ios
  host: ld4core01.net.arkadin.lan
  always_alive: false
  username: netops
  passwd: |
    -----BEGIN PGP MESSAGE-----

    hQIMA7EyDH5sxwv4AQ//eofUS4O+RkStDqdUJcTTgCl7kB8A8crktHyuieGuJmsJ
    MTQ/c0h3ck6Bg5gSE1SssjyF1xLpVSDfqjD+84eGRTrqFsc5zV9ak8RwjPGlIJ24
    sjhscOLx31I4I7J4QkD2OLTuTo8/i9mdcKRm1B45QJKCzoAIqVhSiuQjMPAPDlKj
    GfFPLgcMrvJq+HOi5ZBtiCVwoZJA2zDuFCkRJnHKjjyfDSl9KoleMYol6VQnvPIr
    g0g6lm2NHFUrwimyjps2mkzXwhvZMhfXnCM4TNJmfb3xoDnlgqhYE35+EaGjq5mN
    ARMaDsNBNb99FNOej7FvX/ycrSOw2YUuJ04SJp2H7q26k6w99b++UFnwcUbh6Wwj
    nZIesMWJklvYLicA9JoMnvqknvJYzBrEaJIwNc3sT3esNYfrZgnlJljeVGL1fyYZ
    c+qQu0q358RN0UOefHtX6vfj2P0OU86zefHUOaGtiReH7S2ZbYLMn3t4DeH76Enk
    4ZvqeSYqpZfElbP4W2VXDZ21T7javjxeKXfoSQQ6UKpRs+ztv6xYRjjxLpj3r48H
    6zy90XQaeZOFYvJ8F/zrRAsRX4faN+EwWn/DOvXxibJJdEWBoLbKrliSmQ6aWoiQ
    R4P6E1w3qFD0T1EGrW4qdrCAg1Pcc78C4oiBEYqanJdYkO4xk506o3x1YK0ryRXS
    SwHJ/bB7aeBAizWjIVZNc5rbTDnsLpQ9LI7aS3s0HtaF8IsCXq9em1mToV58TDCc
    qF6zPrO+KO2b0nZScDAxQMuU25pypGa0leFfHg==
    =yaoX
    -----END PGP MESSAGE-----
  optional_args:
    transport: telnet
region: emea
type: network
roles: [core_switch]
