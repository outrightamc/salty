#!jinja|yaml|gpg
dc: tbr
proxy:
  driver: ios
  host: tbrcore02.net.arkadin.lan
  always_alive: false
  username: netops
  passwd: |
    -----BEGIN PGP MESSAGE-----

    hQIMA7EyDH5sxwv4ARAApWepQ/R4K+qCkIoj3eRjiFD/pjetH6K0wYk2qED4ifUb
    dNUhbz5o2JE72Sfiq/h2tn1CGXZxYekxcJbMWrV8p5hNDTg0lBFhKCWM+gvg+9+L
    +wrzxdJIJVmG/i/Uu5Fq6GsuvksZIAUdQ3erxjAd55rpebBEFzvG8S8OCQPoVVqa
    d8iNak/R72hZDkVbQcq5odMHPeeQ3sgVUgAno4cj4Z5YEkN5jyF955j1/vYZMVSl
    3IFexfHcsNKdFQR8NjNYXyI4T/hqBJJzRuZUJaVxRFpkPRUWe+CT4B/iD+JomHYy
    hSJB1m6C0ArVyOP7QGO5K6O/cYvqL8rpoIP1eljGI7xOPrN9TGz+lw/qh8wojVOd
    NRa9HZcB+sJqe/9V0zrHYI4PgcNuLXBu2pzNDRan7nOOf8WWuqYJr6qjdZWsPS7f
    V6gVfpY7+Ifd3NEz4UBUdD8Kbbl4BEQDRgK3x5n/iKGUx8CLI0OtaOL17WVr7V/u
    P6AHtNRGgmeyCYhitUjL2cS5+jTI7UQQQHU/kedV+rrszIz8lZS5pqa7M7Suv4q4
    qpQzamXhBnl0uSCQqHPLaKE2INH0HqPCGHfasoQGlfRIqtPdU1hLcw4emzilexfq
    DP3wU0DhPMM8zSeQNn+AMHajjJ1LBE3NgbzR14gr506ikOA8VhDMyzWiyZ9Wu/7S
    SwHcNtI8wu2OUacWzx1tCd4/GLL7R8QiqbOGD0xsiK0fFP1kf/YQBdB7Y1eh2Qhk
    eH15K+pdKAMopMAKc5/Co3E5KXgFmAawXGlFqg==
    =3pdW
    -----END PGP MESSAGE-----
  optional_args:
    transport: telnet
    global_delay_factor: 2
region: noram
type: network
roles: [core_switch]
