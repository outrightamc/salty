#!jinja|yaml|gpg
dc: ld4
proxy:
  driver: ios
  host: ld4core02.net.arkadin.lan
  always_alive: false
  username: netops
  passwd: |
    -----BEGIN PGP MESSAGE-----

    hQIMA7EyDH5sxwv4ARAAkk6TXXrmmYk+r+OEeTFQEa7FuYWzdKM7J8XfTNx1FbqI
    xbfGX59srPqZmCLSc4gPH6ib6hJTtUzz+4wQLHp1E/MyQz5ArmO2NRpuM/axncPy
    Hk9Q2+BmviTxubTivasuQppwrjK1Otq6Y2OVSuYOzU+mkMSMuzSKpMBn2BCiE3cd
    me6jbCDe3kEO6klp/ZdjT1xPVfZ176V/HPn61FU4OlOl0ZHVG8hZwSGZ8x1kXe81
    crHoi1ecuoIdXT++I5aEZjAUG8/escr4HzedvDplk+cs+ywqOLh1gHQJyYP2gXxw
    r3Eq+pKvA4E/RemFyblSJ2j3Yjt/Uc8rAerBAdHGsmA+e7SCCgDHl2+7f9mqlKVp
    8PBKDCa+HlBMJCSraFjzj+fuRV8tgGW1UqGz+zbROObYCQpGU2Jst4TxN4BEZuXb
    6sCG+atp5vuMKRIxYB8JLKwivYpBUhw6rL7QCsM89gcskRur6UjTsUj7hjYBW2AH
    DTEcDIdWEddDnGaNLqAYDay1dUJM+/jwQ4gUV45PlSc9gPiJJBCfCKhFzO2WNfiR
    GwFf+7ZxnDm/5zAsM1imhPGLjK6KM8+GYZc5nTqLsWGG8auziPjhKL9Y27YTAiTB
    9kOeCgx7thfGuJuJ9Lu/ShrHTyIlpfNl/TKvm6vC8WXNmWF+eT3XcXXJbUCCdFjS
    SwGZnwiRjZoyg1EuXCKidnaWa6LwtpBFg3ZwYxoDxSbHxppYIOyy0QqEShHHfcKi
    G0Z6zWgvX99bV4NEldfZkd9CVpMfhZ2HeQ1uyQ==
    =Jnnk
    -----END PGP MESSAGE-----
  optional_args:
    transport: telnet
region: emea
type: network
roles: [core_switch]
