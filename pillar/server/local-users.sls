#!jinja|yaml|gpg
local_users:
  absent:
    - rbarrie
    - sridsdale
    - ldevai
    - dsantiago
  present:
    - username: dturner
      uid: 2003
      neteng_class: super-user
      fullname: Daryl Turner
      shell: /bin/bash
      password: |
        -----BEGIN PGP MESSAGE-----

        hQIMA7EyDH5sxwv4AQ//Q4GCFwXcXuHb1Q7NIj5j6ukZkHUO78QgRgeJPgQNWqeD
        P2qwLjR9RZGpaaCY4Xt3AljQkohiH0zZdqgK5U3ipElNVSIglI7kCD2RB/JBLdA/
        KtD+lSQr/PGI4Qg90snETsksXpcbGyx8q7OalEMgTHHjEHTYKuZI6451H2/U9b9D
        GTX78C23xd69u3jnA8ETFKgwEQyeyJAOcY8jLHLgbvuR48rmptgbSkDWwQ/UFYNf
        J6dL6mpR+l/G9PbI8DYngCR3PyxmptNuqolXR4XG38uMy8d1XzHIjFp5L4qlOqG5
        Ztz7RZBU/WLIzpkoSVYV9WRteEvWRuiN4cJdZogyw9eTCF6HKRIZbTfmuY50vu3A
        5fEvqpJnlEfGJmDn452IRzdIoiex7GNboynQteQIdX15QS5M1CKIuj4RTlsxsS8k
        gOY7FMILwCtaOQGoBWY++NQmIcoGKmmPWpTTr1xqhGH4qFDPQD0lBdBk4az3kHlP
        sBFlCDBjo9IHYrAQtLdiBUQhiR0B+lefII9qzLZqGFkIm9ONc9qWNJKkwJD2B16v
        HzpsZJxrMls8z+YtL9wBOmZBA8NyziGi83EYYJnsT8bSt8C7KNlwn48S5N/AhbvK
        zyKEBgzMHnlSZNXT33ncBx4hlznQnjBYOxawOmuzU8zghJMDlVLd3YcginebLM3S
        ngGfWqQI3ALzEuPx3RH81oj7Drv/zsnlyHbrcJPY0NuBOJfof2vxUN/kI80jc7M1
        851RR+EpUHU49M66YcoPzPOrSZaZiF2h5lPBfuqwg5UwO6vQPwet7ZMKSTO8yM6R
        eChYLRYBD49tzMejmqNx28Gvj6AELdEAM/0+8aFDfVXppC3P196UmaCWIzNKVBcC
        mvxyBTnUXLPly+Mf7gyB
        =HXTS
        -----END PGP MESSAGE-----
      groups:
        - wheel
        - sudo
      authorized_keys:
        - ecdsa-sha2-nistp384 AAAAE2VjZHNhLXNoYTItbmlzdHAzODQAAAAIbmlzdHAzODQAAABhBJ+4Ee9ADM1vNYENlKqumI1xPvs+bPwBJ0lLpJ1flCGCa/HEvjm2PY5/3Z97CFVSs8y1p43I4pCpIVuaA+WTdeQZ9j0Q3QUgfeYDldNbHYWiJhKQh6qPyEChpst+CDcHzg== daryl@ws_virtual
        - ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBKpO6x+y+CrTpkgRfBq09xkQsjYad5FWBMg0u3stDvmvYdp+VOZbhbcocZjiYPAgQvUAfj2WJmGMijzGVWvwdmQ= daryl@mooncake

    - username: c.alvarez
      uid: 2004
      salt_id:
        - atl-bastion-01
        - ld4-bastion-01
        - mtp-bastion-01
        - pa2-bastion-01
        - tbr-bastion-01
        - chi-bastion-01
        - ifc-sltprx-01
        - pa2-sltprx-01
        - atl-sltprx-01
        - ifc-netflow-01
        - atlnetutil01
        - atlrancid01
        - pa2dns01
      neteng_class: super-user
      fullname: Cristian Alvarez
      shell: /bin/bash
      password: |
        -----BEGIN PGP MESSAGE-----

        hQIMA7EyDH5sxwv4AQ//RWGOI0Zp6750gzi3hDcInsiSnI8vlgtfnAS2LruUw5me
        tmV8bFaLbKrXcKUr5K3fLZ7Xby7Z+fB55anwgO7TRPittiNJogyBMr97f3ZRNf6O
        T6JJ8jgn+qWTbZDnIhn0gmBexyl9RNc95r1CHBrL6o3Gn/rePAykKYka3m6YMcTJ
        HNiHk1Bd9H3mmfNJlradB6Zqyxwijlp9OtYbXteYNy4hhgZOugql+YdY5McmI14G
        r+fTgD0e/ruO7hC4ZeM5NRW+avOZw8ViIbTixYQ66pOTQIUnYfHCsbkyWae/eUdn
        Eol+khjfQl/C97IO9oL7lrkHdfn1wyVHwbiSqmZ9pwd+C/rAVhZ+m4pC/wpRnEmz
        +JLEoZRY6/IiRblSBH1efyHWbsezMsjifnpcgFTOaSzd8I5UGLkJgFEf2tRbbJxq
        c2TyxkbiYkt3CbevAnArk+NdZrkXJP6lNO0wNI0fOF7qGKxcC7KuDH0UKO5IM8Y0
        06CviB07v8w3amo+Wzg9KHyYc8TKrdNxZnen/qscAIGwlO9yBj0+vv5pjH33sF4U
        i0aJwXVS0htuMod9yAwXqlUVCKc5LKjW8Q3julo6Z2WAPecPwPb3FSYmiLUZacTe
        WoP+ol92/3P1AflauwLlqH/XkpCJCvGzG1QbYvMhF4Mj8MiZWMg578VwSypBX/PS
        nQEH+jGGRIxZdQ7I6aDlYB0VPswGRslhSLZG2noJBq9qMu10r9XahALkfc2QRUuo
        23jS70fksPWVCNfOOYCGOk8+gqXZ7v50pH0L8iLAhQCYJyE0ZA1GwGBguLTHTM+v
        QtKoV/Xh5sGffFJFuRlyVDNZrOKvwe/7DrvhETKbDZ+BEjOrNJsM3cItoc/FRUHN
        Qo6i30DvfRW4UpMHnH4=
        =MK1+
        -----END PGP MESSAGE-----
      groups:
        - wheel
        - sudo
      authorized_keys:
        - ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEA4r0d78ARpWrmeGMyMBIdNmQsDwwEKB0YriPDWoswpQ5szpRIhJ5GUiAuxjtUdO6tym1kyOBCYIv5FXKaGk9V34b/regK7GD8ldvIU3zcjidLKmaz08qFUA3ZclwDwiiEsDpc+tTrOZMILMnt9OrbnPXd4a7szr+uGu1Emv1tJwQjv+825PggSzaXJ8qe2VyAJ7UFoB7M+3J4DnkEilCX3fT/Ld6I5ea2P6lk597eI1PE7J4o3P8Tub5QQDhLRr/bQV5XVQ6OUhAq5Rt7bclXrVtgncOx99eICnezADU8sYLiTo6/aYbMZUSc6aOe+6SUCcDKa2BCg/AhaNVcuFytPw== rsa-key-20180802
        - ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEAvk2YPyeLAAr5jD2/Bm4yvSktV+0iumaHdRB3eBGY1eOG0ueoMV2LSwD+BFZjdW7+f4riPp0atoS5fu3nMEWTVjDSw7BCWvV1ZLUcXjws7QZFIPUoJATlm1516Qjj/LEq+eomB6Bv1/TztkPNbfQBq9tCZ4pm255OEefHxrILn6wJEdjV8z5nP2/5/pUbUznHa0902FGGQPrFyoLjPSRo6KmrbutIQuQa3TGtAu2jetxjYUW4OgashUZer2SVJzkY6J2srQpo9raNPz+ToAsK/SYPLjEjrbfuCFAyujQDBUtupqT2l4pZRRNqQbZaKLGTFbBwalTdTmYkY/rK5jJr3w== rsa-key-20180802

    - username: cgrant
      uid: 2005
      neteng_class: super-user
      fullname: Cornell Grant
      shell: /bin/bash
      password: |
        -----BEGIN PGP MESSAGE-----

        hQIMA7EyDH5sxwv4AQ//UuErLbYoxvxHpmYK32DVM6sDUmFGCfYcpSBHvKf0n9GW
        QVkgdB+0T1MGg+3Hv/VS6Bq2IQZzcoQYvyXz+vM02gQPSeT4m+ovk8Z4qTVwvBEe
        so1gtHsvWgOJxL5v4NpgyQEUIuEmmEcse4wHB5BDBkrYBVqnpttSVijjifyJI9oP
        UBpRpBrGAk5qAHQsWdZ/nokG7YjD61+e2lYouGQtyXgXoNBA31QjD3XdJ94Gg32x
        BBSS8WpbrxLJkG0tRlI/umgAFcMYX0Qh0ADoBAxDUyHf9xr8E1m8srlDWkjDmGeR
        GiqCLiue3HrEsWr4iDj0aRXQDVeD1bdg8GiPhLsLp910f1so1x1ftEe30BaUREHr
        IKU74CbCQ2f7Ktm9pBSo/2oCaNYn+2Dx7tMl252JQXK4QpoWjhVUwDFOj5OhM7ge
        YfP5/mPk71E3yIwnccYu3iV4vRXbryZx0NmGi76Q9+qSOVVAAKwpIGymYhMRDwB6
        30DsT3ZM/0nMS8ycFXF8hHbpCJPiofIuUB5RaBU5F1mZxNq+F42LcilDna46VLxP
        usVbG/Ftu9jRZ2tyClqimEwBrhOIOIWkLuf1JxvnY+O8ia8afPEMQD718mG0WkUL
        FiZZVkJ2CHrKUl0ZBQw3WbQpXF32S5cdpGB62GBY31fsxbo4c70GMvLUUDVYfnDS
        cwHxxrZtqF+LuzcwACVIJfflTlyvoIN9CKGBzts0LZteVwtjsukePQEOJKOhj26E
        rUp//9oCA8edWrMqCCmzV8TISycEaZ7LNeOz671Rhl8shkaRB7sgo79r6RF6zIRe
        /i5pcYN8bB5u/xxe64ws8Hlpk/o=
        =1gwl
        -----END PGP MESSAGE-----
      groups:
        - wheel
        - sudo
      authorized_keys:
        - ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDTtsaxKUih4/BwhxcpOcnVw7oAHfRabgUM9lT86XT3hQPMp55UbKA/Rc4Pl0gfA88Km3MZJE2P6Uqu8vHG1+7aOYbOeXkAU2pbAdwBvhYljwUCcLB0uKGpkAksZjnIXOtjBnJTzeh8uzBbQZySZwK7F4bV8sR7wwT/se6N2AMsf/Th3o5dBcEVAPbQ/wy5ZZffbzO0MjcYUbpnCftO106T7kxqkOnmLaGf59Dq+XayQWzolPcln8lEtZBRvy4NfUf8KXyh+k5K0lb+f6gshK89mCn3K6RxaEDjCTt2v6hnPpjGipif5yMLwywk7PI/ND2EU8DEI396a7P/t1s11I2OZhrW5esdolRqkKAK+NVQsMlNGCKQfHUNjUplWiFM4L2AwLZAWpbiIWWwcuD2lrcSbToILFrESiybTHyGSg74wXtnab4oQ/FeQGz+T+b3v9yhBefyIUDC7jLXOgl4Ju60VLj42/vHZhH3zbNf25JD68YU6Nwu1fERvpUGYCgs8fTUJPmraSdC5JOppBZS59mZfar8AnwwvM8VTBYfDw9aWj19a0d730HNJjhSa6gH4xwWP80MM6L1+afaUrc3yQK39a21SdqXVCgXUQ43e59psTjgN1RyzoUm7F9BtA+X8Q41eiMlxjoSzu0FIm8//AMe/GVDT/av+Mle7uWp4z5Nkw== cgrant@arkadin.com

    - username: sklamm
      uid: 2006
      neteng_class: super-user
      fullname: Sebastien Klamm
      shell: /bin/bash
      password: |
        -----BEGIN PGP MESSAGE-----
        Version: GnuPG v2.0.22 (GNU/Linux)

        hQIMA7EyDH5sxwv4AQ/8CbLEM8D6Kg0Q6Mf75CJ1mn1sPC/OciBDjtGj58W9+E3G
        pzRqENXHxQYGF4qmhI4pDRe1BT6M3RIyPjscT6TLEfpYvjGvYiYjmCaEm3WygyWC
        FCVUGvkXYQFmbgpfhWwq1l0ruUfOui5HPFqctfoaaZRcR/0Brq9HQJxa9s0Heizs
        0ubLOtTdJnJuUc8xMlDYJCpQs3ieRhaQLfxRVu417YTv1wEO3vTe6tYQ5qdvsi9G
        v+9FGHzmWCKEsMMnbozx2srFtq0k5F9NUiQitVZHnb3/6fHpSjOBxKF+WXmUXCcA
        orq3Rtl3IAXW/UNzwi7jdsp1Jl8ugSEP9wpmwjudcO3kboeIAxNbVwp63yJMPEQC
        q2ApEdDfdDNRLNKPFLTUW2dn/puvRzl6JyU1prD3ZQ1PfQDfV6xoOsJZZlnw6i2E
        B0/CJewmftTrJQpGftU/SVKA/X2D97BZPD5WeN7oeTXLs846nIfhq3kTPFgNmMpQ
        g+emdXs9Mb0/5u+hdzqPqWrRRRSVXCeEKUUCDvKmXu4oEenai304k0Gsyr3KNuE/
        9K+L/xLISHn682qJ+gH2PvgjcWKSnx8Ww8+DF/PLz0C6ViBGaifPNpojo7FJUnj9
        47mqDeyHygFfmF+VSPi9EZQh1OyREhYanFiyHzmVxv2FMqQJCRUivZxP2zXXM/TS
        pAECZ0CirygZO0ZcsuoH32cMEAzXEksIwbJwoKurSHATMdpCd6PhI8UfWuYEDx9h
        P+Yqc1UB9abKJBz0xZj/lUqxllJs/k4ZUwtY8LYnsq1e+KmOyGNEvE5z1jmf06TV
        egWlooLauquhvXu9ggEcOWqOtsMeDRQL1O9Il81mxw6xxWKSwTuLMEKOrRqraQDN
        M7SHf4wP8CvX8AjTIahL10z6FtFj
        =DU05
        -----END PGP MESSAGE-----
      groups:
        - wheel
        - sudo
      authorized_keys:
        - ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEAhqQrM7zkkD6rB+aCvIfDjirmrjImtQCgutkGoFKYSxEoELVsDRYwX8j2nS1NVvSc1T9mzzhjitEh0sQo682nsKqQBVaxGKWQZ/VvZwOClEEofM/8gvFJ0ORImhnidCVd7diRnSeCtJ74QpP2B4A47/LJaeMXNxyCnmh9TNMMh4stG761BI8gA3xVCpKZEPjLURPrIzFBh33rl5kHaA3uFtfz/kXVHxjbKpjTTbmQhqjIOxDuWOG+VvMb0lVxM9DixmnqaF+/QQzXAVfPWA7GoiAOZzJIe8IntnStMoIIDW+Ya9HEC/r8krSpavUpJ6VPYUdqR10H1Ac007ji4+U8nw== sklamm

    - username: ababson
      uid: 2007
      neteng_class: super-user
      fullname: Aric Babson
      shell: /bin/bash
      password: |
        -----BEGIN PGP MESSAGE-----

        hQIMA7EyDH5sxwv4AQ/8D7mUJqwf75/NqTKDetIIThElhyc+BA63zrpo9Y5NkaCC
        XK1NjJAXRBa7MB4RIxBWN1iBLwPyRRQ0YVBqmIwjAUyhdQs0lDTAjqz/hia0Y9S1
        LCOD73b++MU4FS2vam6qcc6qVt2g6lUoCR2mQnKefI7WXXfilQKHqQW2220V6p/0
        +XpjghhaISRUgJKpR3BlVuY44lryvuxA3eRgec8Ni1C1XdG9ABQmDwEDNxqNMi/2
        UTA7XQoygKBwMPZ5o1BVFtIpilrzsiVoH4mXlAZU0CtRez0+7G0rxPz+4X0OmMlc
        k92n2BuwWJ/l3Z+IHiPc4Jvk7VP5d2wn4yBQmuiMSjkwathK0JWf5trhhUBGR0Jt
        3nAJUq3I+rciz8pMEJhcUmMhEnoQHTm+7RzRwfmt305/6LLwtp7s5kNFqfbT2jW2
        WS8gdSSCtdrLTJckIEFlSbxAbKghW1dGwzaa2Ai3khUMQ1oPeDW/i2uv6aD3FmEl
        co33i0MAaVp784T2n4/wvMRuX4jJr51lemY6ThI1hcdZDf5AYoy/cXLytaALI3M8
        sF6FH2zZqN4d9wXdV1EUYYnoMMG7qNiiN4X53rwDMg/EnxFCR0lXbvpXr8J9s3pJ
        r1MF2M6qbFhZbi2NIhzYCRWew+/9rCHCAnSn94gcbqXMSjCTauvnW6+UU6GI8JTS
        nQEiNmE0temapQKAtx9/glGzpn2wazlycJnsniaa8aK4BFds0WHL3tadYhSVFw7l
        JHdwbvkU0lVW1musnl9NLgQaZmPHsF0srW/k1jNulOk1pDVJi4PI8R6XrxG+heVV
        TWX5mvPS6me1cs3TNXrOUUSYtqhit9fRRGSiC0CmQiS4bb7HZ8tky/8DRg8JvvBv
        vaLmUPchVpv8UxJlRHU=
        =JJcS
        -----END PGP MESSAGE-----
      groups:
        - wheel
        - sudo
      authorized_keys:
        - ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCihIfWAK9f9R7aEXrpn8kjlXklgLckvfmHFMsm1DUyuuNGVQQq8SfMGXnzTn+JHB0speb/v6ljHpTnYnVKNTFv/FcCOYXJiWYHcKPGdYOLq23ZQBASRrL/7zI2DUOEfrpxLYxafW3u/y7koMkyXW5I4CmTdbG/Ydfa61d68+PXm1kjihoVvRJmk131IVI4RsLpgi3WxsCT/I/WUjA34SBWtXwxC2dQe+MH89HqKUNdHh0mDvRNK/WyMLPZosuTfdPd5RF7zVvEAHkd2WBep06xl1N9ZCtXVmmnuEl4V4KIbM9vOoXirWl1b2AaYR9RqyZ5IGDGK7VsAYwR3e3Q+WLSul83aCpik91idl40599CLt5I44V778GtWNyjT6TWxfJWynkgGkxqjCLj1zL+aLMOaAACKiYrPJ1XVz9702rKvIDEmmyVqk1xkM8CcVM4RCYP8kBjVvX6Hhu/uEMltKe86dxPUW9SXDDMXB7wTfYHKZqCudmzj/LdPYTQR+w+sfYjUomZYZKG71I5rV9qzycanDjZLrHrOC1T84wpYvtW9S1kTnYT9JkHzJG/nmBT45VCjQ+yKDem8kIyQGKO1rXN7QdkAQ/3qcgDBudgJvPnCBJJT8d28VjydjhSH4iG+fekIn7KjpbdhObLCkNAHWE9grs1Xh2X5zWcp1vmadXkQQ== a.babson@arkadin.com

    - username: oclapinson
      neteng: false
      fullname: Ollie Clapinson
      shell: /bin/bash
      password: |
        -----BEGIN PGP MESSAGE-----

        hQIMA7EyDH5sxwv4AQ/+Nqzt7RtdFkHIYvP0v3L+dqx/PIosSt4Z3h0K0wpUIURU
        JtOfeX3bKhjWxmzXC89aICFi7le213yD+QtaahjBSMBiLl4VSQ6eSleK1VJR62jJ
        wWBS4EKJ373hflgVp1hmKaE7ZpglrafZmHDTXveXPGZjp/W4UVr5fKKDLULu46x6
        mygy7HAPz5UuIqRj9ph+duEZPrruOvKpBpx7QPiW/F0dx+EEJov7KNccbkn6WY6/
        X9b+bqG8x1L1X7ypJzO9o5P1sXRx5uO2CmRDzWn0361PfjHonQkLtFyCuh9SbmMF
        219f8NfcBrK/zKpXtv5cEw7MTFm+94dD7bl/8pfYI73Z71K+NjL09lHOigbXr8/5
        btflALCIPXNB/q8lKjcmHQ1MMMJ/rTWRgCJXivQSwo7caTyuiOgFx1kdrDa7zG6j
        SYwnn/mEMjV1Lm4FyX1p6gWRaXv7D+DR52xgR66j+66VecnQukqipZxVhq18ytAL
        9Ee3zodLRj/Bxti3zqFLdpsJ2cHr6f1BabkvtrSgw3aVU2b5pAWElNC+GPxKdvqp
        K6dyxXDa3JbA/ARng2eIP1hQMnJLCa76WID/pjnkrs3ngrr3UpL5lhzDB6VkRyck
        DrHRpjwjCSU0dhY1yb+mQ6BbcNtYhxNGuH2/UXQdr47wYp2nBR+lYlZ5Hj2JSHLS
        eQFM1LexvyMm0IlVHj/NDBS/9js/c0HCah4DKjUND7OGFWht1wLRY4JCZo5Sh/YU
        owGwfTQAvfWQjLykpf9LwGR3f1yDc/t5uRbYtpatoP+R2auLLTc3R2C9dIWsrwju
        hGK4Xz0sAWagB/c19J1VJZcU3KwrKYmG35M=
        =KjZ2
        -----END PGP MESSAGE-----
      groups:
        - wheel
        - sudo
      authorized_keys:
        - ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEAi3D8jDo2nautXhFxMkBdPkvaIaeqP8sWLHbcyC2PWOHfV0PQJK3NsPV+eqya+Z3gbnYercSfJ3tWJ+TOs6zjJ6AQX/bHhwV0fBTdRdx32WS0ddiSulVwHmLuTPClRqL385Ue9u1rgp6Kqdz4bp7SecC8QcmpwqDJsXrQTSjtCEOhGItFeDh1XSNa3i72fb4z0GhSMpxCRwE9ilMgJ27cLmA97a/6qsZzuqc6klGMvc1yUlwvc/qadzjMlVH6bTW1QGIUU0x+RuTdcGxayxbF/OOYQFnnElSfljs0c4A48JOTqFCtBRv8bcILJa9wDI14RrRw6rripYcV+eJYtdS8nw== rsa-key-20180719

    - username: jklimek
      neteng: false
      fullname: John Klimek
      shell: /bin/bash
      password: |
        -----BEGIN PGP MESSAGE-----

        hQIMA7EyDH5sxwv4ARAAmw/6JucgxnbPN5PKk+jWMd0iyWs5rUNmCYHQD3tSeEMX
        v8gIx2W8FEggrzDjOndMRp4vFAy5xlK+9IqXVzT1zb9ismUb7vjlQDwG5afk8TbB
        5yP3yYNapAZs+mOC4+orAfjXndfkFYGguicHsQq1ZFSJTYXncCEHMVPwvYbmOszh
        ekMlOWO/Ck3rKB5VX28ERQvZsWmhAzK6kN8OaHbFgfcoF6ecO2hElU1ZmQkZ5q60
        MK7+stqwgMBS+8sgm80Q/nGj4spViov5mKdast3qDmnx+lu2eXqOH9zxHEBpVRd9
        8kyUCm7T5l0q4xzwGQU6SvzGJT7T7BxI+uWPw847VtLYPgIaDRbwqNjYZdgMNz9Y
        aMJOaUsODgf7RDBXm/R9WXeOlL0p1e6ckbSkAfTbGLO1PmOlUsI2p+EzXF9cNti2
        6xc1MOgblLgFFLxFJqSTXjF03cyd57Os7olzVcieAj+rBFnHS3/isHsOLXjFrPSe
        tMMYrLmpywWjdi0rAbvseiOdAPCz5+FYt8Fi/TbnH8/5Rav83rYDat4nagll46+v
        OL3obHtCHyHUMrGveXDMJ+gFJIz3y1imcfgRq6EfC7BDsgVkTw6U1L4fyy8n6olM
        bistsmtddVwgnC0X1G7Ao6JGYH+jh7U7rOTSzzOZOkR+RjQqzvCOG4ehCHJiJ+rS
        ngG8EgfL7A1ocg3TKozuI6gXomKZ/9qM+/BY41bb9lZdvz4Hp+Q0rdiNFYZNGYda
        S/1ehDzzwkZtGDVypBtDFwcpseCk5BqPFI1a8YYRgJdZRuap16WzIQExsbUqY2v4
        UqrRmXUvV65CcmZqrce61qocqCgYyy2LjGN/9/I+m3Q/kdOYiYR0UGLrTcUVxEmT
        ARBW2u1dhftkfqzI3PqH
        =Zyw/
        -----END PGP MESSAGE-----
      groups:
        - jklimek
      authorized_keys:
        - ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC2zkgRtClYNoWzw8BuSXS7tSxQah7T2YxGKZw6l0013Gx+DkKLeOgwkbkh2fdQxPjLu0EVNNkHXHU4JP188CizFkpwiYfe8x+2Ftnwuo9f+vzxj4301DolT6nyWtodIl5yhLPqF9DhuChvxMLlciS+OzQYZxibST1t3ZdPYS7wrrwwE7Akwdbv+U1GvU4ucdFnXbcbkzAvuXBteEcQh6BmB3ol5hkaDWvVR3itFkBMuXIlsS1fj5CNcZSTxiLXBerhfQ2kaRwnlFOdZP2TY/vwc3SkyPVdebfkYqJPSSdXQY0P8cXcQPgdx7/ZftnL4H8kJ+jwx4IzuB3Fz2EAvI2uccgyPBNZIb4neIFouhVlq/eGcV0rErYMSKusClirZqkns+QjNzPccELqONbcmUNdjucfrRFcnxuRpuVCNtcWDvHZbWqVLlVS863gRdGIJ1QMRmtz0+iTaUuJQoWGyu18mMZj/27WpgjPVbgZED0XlPAI63uL3oWxqgpRGqsngLPty9ByVpNq/eXtO53/iPPYhHZwefO2dnsWE7IOhSG7D9NSr21tWmiUvEgoMlT9b1vBqB2ne3iTnV4n0jPC7bQ63yhQXg7JHZKhVCEfedw/d233pU13+OzDFVzDMYtvL6RVajcgOIDY55Hm+yIvvChzRjK2VP32CHbT/ZblAaA7aw== jklimek@arkadin.com

    - username: ppaiva
      uid: 2008
      neteng_class: super-user
      fullname: Paulo Paiva
      shell: /bin/bash
      password: |
        -----BEGIN PGP MESSAGE-----

        hQIMA7EyDH5sxwv4AQ//dDurVxKmmMy2Tv3TjUbEipBs3BVuHMavNnE4bvydigUb
        5cce2ttHLAKAtMROkoa+wCnONZz60oK1o1meYjPupyIlkOwXMlz5QO/H6ti+WeuQ
        BHmOx8Wj48rblsmljGBLVLgsaseZOhzUxOhgZ7EKpLCNam6I8FHM7UhdqhRgG+u6
        9ombMjm8aq4ENCkjaEInE/ZLQMMl3Fm7jzWndAKvGUUr/WW/YegyjEuq5xi1yUhI
        i+Bbjls6PpybI6Bcz0Iw9sSQQ54pB+bmgB9n1dsqzljZgYbaabWQIyP0YO6PrCjj
        EvZhvptDZzBU8sQf+qVhvzeWoQ6jpRDop1n9buuc11I+1PnnVno2OFX/nsTm3678
        wJ8F6s3a4NPSFv7z1FXo3y34j4quDbBgd0gNp97FxGS6ha5fEH4pg4wnqgF9mgE2
        FHOLs49RdyenCdNCNoNlxCyVisUaxlTQlAwtrIM0n8xW14O7AqPuCTNZJW+n45qB
        AxQAL8dC5FAvbuIbg809u0OUcfWbjLZllV3i4IM0kREnnotWgJxF+Hnxyc14yv9r
        VCeMmchQd7SfG6HXqLobzeE64VXZvPBElPrIUwSZBeGJJ4e2yC8iHMBGnMnDopv9
        Die/SAciQa28bBpyWeYA2hVVEWqGn3j1P1bXQvLKJISk/xi/FBbKJW9iLwR+K5/S
        ogGy4bIq+v8T6ri8qtb8BzTMtlfYouPlYNJUlIyw3TYGl5olUUZjpCYDS9DDXKUc
        gmyOpwaB/rxbBTDhSQrMhlNWSSLcxP3XjkR6muzB3CNq/ticoHRukxImLT/VCbCP
        R+rRFVfdWdwZETCr/3TCYiOCBZGej2nLXK8oyculh/j4hB5P6ffwsi04H+G4emP1
        GIQ8tmKfK77Dcx1ihlEIj3jVkA==
        =l80z
        -----END PGP MESSAGE-----
      groups:
        - wheel
        - sudo
      authorized_keys: []

    - username: vmaselli
      uid: 2009
      neteng_class: read-only
      fullname: Vito Maselli
      shell: /bin/bash
      password: |
        -----BEGIN PGP MESSAGE-----
        Version: GnuPG v2

        hQIMA7EyDH5sxwv4ARAApg6/YWzAjkiWDTexvboXQvYnAMDAbzIzsk5ALWYmQ1wB
        hJHRrd0eHzl+ZH3OMfV2Fsz6IfJ37WtKPCIXPJgS4ltClXK8TCwX1AoAvNQjMpEt
        I8fvK1og3Bq+I3J5YiMqsZ6ZQKm7ZxGmlewADJI5bM2q8mQCPLpEtYr+CHswpKqW
        zRTL83NB+9a/KxAEZ9dYBdeYt0bwunJKT+jkrnqmW1WYGAsta+nTCeMJjpT+5nPy
        iYdaEW7gbVppcYiHT66VqcZBEndKRv2di4X/Re9+FSkKhA0Uqrk4RJmWxrHf4wuY
        IMJOnMJdAR4c0bXp6ded7vdUBl3dxRV4cWfM+ro6LzfQjRIVSaFPMa3Q6lvCCfNC
        pbGL+aqmQFeKNzRI6ItTrh7T8hSLUmV4QDsUuEtMAd+DTnpHBFtIQ0/P6eOHVAyR
        h0v/qdpapIm6nNRcvTJMl0MbFHNbVjCRue81TSaZPh2ZwwtB4s1WEOlWwUNj24Yk
        znmw/mbGNcKFH1Q58NrjDcT+JKi6jSPulM8cmV3EE68viwSkwOEYTo9rNkWjrFVW
        WBaTgkEcmufC7fczEZK6qO0pC6z1jF9719ni6rhfcxegiW+unhE0VhC1nHfsSIRA
        H9U1KS7mY2MQf0+Im5OZSaky9lLFod14OpL9Eiih3YmheI/yknjCJ76w5z6pVxPS
        pQHkSSU7/Y5xFbpV/c1QqHwaB4hd8thfAUlv+U661bAgAvXHqvo2L3mYaGuZADC6
        mLyRkXMDLskioEeYmvSEP3Qg9I7M2bhFxb88hpYewMKGibWKUPMKug1DTO8TcJvO
        ALRIDIykp5nJ3DKichZaTi3z4qBgA8XFCxK9uPA5VyccBxKSMqUfexXqdGg5DpBc
        vdT/ZSSNGF9OhYlG2VuP8BLgIsnFag==
        =wvZG
        -----END PGP MESSAGE-----
      groups: []
      authorized_keys: []

    - username: plixer
      salt_id:
        - ifc-netflow-01
      expiry: 18308 # 16 Feb 2020
      fullname: Plixer Test Account
      shell: /bin/bash
      password: |
        -----BEGIN PGP MESSAGE-----

        hQIMA7EyDH5sxwv4AQ//RWGOI0Zp6750gzi3hDcInsiSnI8vlgtfnAS2LruUw5me
        tmV8bFaLbKrXcKUr5K3fLZ7Xby7Z+fB55anwgO7TRPittiNJogyBMr97f3ZRNf6O
        T6JJ8jgn+qWTbZDnIhn0gmBexyl9RNc95r1CHBrL6o3Gn/rePAykKYka3m6YMcTJ
        HNiHk1Bd9H3mmfNJlradB6Zqyxwijlp9OtYbXteYNy4hhgZOugql+YdY5McmI14G
        r+fTgD0e/ruO7hC4ZeM5NRW+avOZw8ViIbTixYQ66pOTQIUnYfHCsbkyWae/eUdn
        Eol+khjfQl/C97IO9oL7lrkHdfn1wyVHwbiSqmZ9pwd+C/rAVhZ+m4pC/wpRnEmz
        +JLEoZRY6/IiRblSBH1efyHWbsezMsjifnpcgFTOaSzd8I5UGLkJgFEf2tRbbJxq
        c2TyxkbiYkt3CbevAnArk+NdZrkXJP6lNO0wNI0fOF7qGKxcC7KuDH0UKO5IM8Y0
        06CviB07v8w3amo+Wzg9KHyYc8TKrdNxZnen/qscAIGwlO9yBj0+vv5pjH33sF4U
        i0aJwXVS0htuMod9yAwXqlUVCKc5LKjW8Q3julo6Z2WAPecPwPb3FSYmiLUZacTe
        WoP+ol92/3P1AflauwLlqH/XkpCJCvGzG1QbYvMhF4Mj8MiZWMg578VwSypBX/PS
        nQEH+jGGRIxZdQ7I6aDlYB0VPswGRslhSLZG2noJBq9qMu10r9XahALkfc2QRUuo
        23jS70fksPWVCNfOOYCGOk8+gqXZ7v50pH0L8iLAhQCYJyE0ZA1GwGBguLTHTM+v
        QtKoV/Xh5sGffFJFuRlyVDNZrOKvwe/7DrvhETKbDZ+BEjOrNJsM3cItoc/FRUHN
        Qo6i30DvfRW4UpMHnH4=
        =MK1+
        -----END PGP MESSAGE-----
      groups:
        - wheel
        - sudo
      authorized_keys:
        - ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEA4r0d78ARpWrmeGMyMBIdNmQsDwwEKB0YriPDWoswpQ5szpRIhJ5GUiAuxjtUdO6tym1kyOBCYIv5FXKaGk9V34b/regK7GD8ldvIU3zcjidLKmaz08qFUA3ZclwDwiiEsDpc+tTrOZMILMnt9OrbnPXd4a7szr+uGu1Emv1tJwQjv+825PggSzaXJ8qe2VyAJ7UFoB7M+3J4DnkEilCX3fT/Ld6I5ea2P6lk597eI1PE7J4o3P8Tub5QQDhLRr/bQV5XVQ6OUhAq5Rt7bclXrVtgncOx99eICnezADU8sYLiTo6/aYbMZUSc6aOe+6SUCcDKa2BCg/AhaNVcuFytPw== rsa-key-20180802
        - ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEAvk2YPyeLAAr5jD2/Bm4yvSktV+0iumaHdRB3eBGY1eOG0ueoMV2LSwD+BFZjdW7+f4riPp0atoS5fu3nMEWTVjDSw7BCWvV1ZLUcXjws7QZFIPUoJATlm1516Qjj/LEq+eomB6Bv1/TztkPNbfQBq9tCZ4pm255OEefHxrILn6wJEdjV8z5nP2/5/pUbUznHa0902FGGQPrFyoLjPSRo6KmrbutIQuQa3TGtAu2jetxjYUW4OgashUZer2SVJzkY6J2srQpo9raNPz+ToAsK/SYPLjEjrbfuCFAyujQDBUtupqT2l4pZRRNqQbZaKLGTFbBwalTdTmYkY/rK5jJr3w== rsa-key-20180802


  root_password: |
    -----BEGIN PGP MESSAGE-----

    hQIMA7EyDH5sxwv4AQ/+Lc29wk1znBa96Zo5w+rR9xGuClezFJsNG8EMLwrO/UAj
    WOvvJJ4ni6nmaubC/dViZagY9zoCze9Kh8d/rZC1BMhh89OGusnM+U1kwEDUunvS
    sSdyJR0hJuZ/SAjxI8TRwy4IFnQAjRe1mC3Ofsun6E8+I1WmplB0qHZcD1YXqfXC
    /eVNJJps+7VL8vltxknxVpTu+29TiVeaMsZ8jr6+dQzUOsMwkidJYfqAepK2+9zZ
    +V2uqsFaPLdAa1PbuJrh1EhSn+Zhi3KQK950JMLoq5iGOwwIxHo7h4fCEG+dqYfy
    80udvIX858RmQ+MHd2HukpIW1VC2iCMSd9G1mAV6k/wM1gZn5q/5Cb07IxmSKAIj
    Fy4wHFLq8+ra0dquL+gSVZ3y9aE4aHlpMz//hjEoJ2WV4tOOWfCFyNW429pOw/Db
    opB4v0DlP76g4y5ZMMmoRGUPDTBA5AmUaUWKhfadUDT8ufGibCi2XJiEWYswp5rT
    DpLjJeH8+u8y66A0XFo0lrJUwbNLqoXtHHK7qP784ratX8kLEM3cfecAUTmDu6zW
    UAbiJ2XOfAvLH5ZZAjNppqirPIH5EJWhJCnT6hOGLmxInl8beuR4owQD38Vkt5ZQ
    1A554Fk4ed5bPB7+pbCwhgo+JCsSK6adRavv83XB6OuZG4p67TnySweHzgNpTKLS
    pAGPXCPTirVX/7Gnl6XXPI5lR0fcnEccGRmw2rqkKmLBWHhecCCoJFqFuAUPiwna
    H07gjIrIjhU5EKhZJXzVnHfq3Y49TuQDHf2if0kbyqHYvkHjCZ1RZsk/EJAzpF9u
    2eUWRTotgQKW4e8wpEB1FEqkqKVBxtZFO+bRz12kdqOY0OecJK7PBaley7Et7pDI
    EhEn6LKQciT77EiXu3wHGUkE0045
    =QKvq
    -----END PGP MESSAGE-----
  automation_password: |
    -----BEGIN PGP MESSAGE-----

    hQIMA7EyDH5sxwv4ARAAlSCsSJHIICvL6DWGd+q5Za814kXcVSC7yjd5ffG5ipaA
    L//anHUGCtIhSTEF/KSuaB0FYoW1V/QLIQMDfdJkSypZBniEhdx5BP0dOEwQYjvC
    CTEXbcGRivxTUzUmWqLOEaQ+7jUaTIPGG4snHrd05DsgKIlOl4Ja6w2cwhNhShP3
    La8z8NbY5z1hLEp/uvVo5aMnzHSjdLSYxUryR0GHiauXiRzTJi7KJr9u5tr/qiGn
    YPlefuSDrLxCwZ2lto0M4fz9+rSItcjQKftcGa4lgk8v3ysX7O6ZDNJNtOyAA2+p
    Kb34abtz04HeBxPjMw0d0sWNp1z2m3TlLebCVDADY+hdsTxZ6WfdM2iEoYJebsXZ
    euPHBfjL/zC57rJMgyfaEGTJjA/oYXrdksN8276JKS7EitaLLfSiLhKNTzFZBH2B
    QXl14vl2E3/aZZUH/yFIY69XbNb1IRIbfmeBMeVGXXSgbM+WiUb3aamIsSK7Lj2E
    2buFvN8zf0gE624aorqUumkHiTqObmNcn9scukjx9pmuSlQoMAy5GYL7lb+2ZQ3Y
    ZJ3Or6O5aDQ8U9vVFRCrRFiZLQjGI7jw9D98owFfWrIjPyRy2n4eTmdn/94tOd/q
    7bhaNNT94tb4A1XWzcvsq/DSPvqso9baD0MYtNMcqrSuzjc/keH4Wvn+3nH7ldDS
    nQGaGgMwe8d+5cF9jSJ31J1iKlGi0M9NLLJHTTHIqf2L2nWpJBvDyADIJWJdMas/
    we80Yc6iV26y7XGTgDXZ+dpvD3BvT3IHKakBeRrQqnb3mjQIIjVHxmuilgDla6QM
    meOcDl0IMFreVZxoYkgmHxq9ZAJXB8k7jB31ShDIPuBDlWkm4HcBGZXlQQQ/oT5B
    sLjVZGi0mJrvOdjUtro=
    =DBF+
    -----END PGP MESSAGE-----
  backup_password: |
    -----BEGIN PGP MESSAGE-----

    hQIMA7EyDH5sxwv4ARAAoHL9JoSjXZSceczBfA1MGym3UhD3dpsJCbwjVEqWIfgI
    cnwIzaGQODCLtxV1UZqRMX/gzk1GPRv3W4oD+PM/Mw/mYjsx3U2DFiBczYY46XkH
    gaNkh35VluPu6WAC61TenvMBOMzDvwuQ6R1jlM0Ee5e9Qzm3X9wM1qw8AUC5x8Mt
    Pr9EjSjk5MZS9lEmbd9ZNP2DWhxvbVL2LtW4Q6bUyy32OvhWZM0dza1KYWV7X44U
    zCfJJXn6WamYt28SXx6RmDOaaSMW/yH2hRFl0FWw+OIk/v63Y2w56tyJhtvndnAF
    eHnvXzjJzdDkXipdD4aqT2XXg1cKS/ikoAz93GKBL1Re2Jt84Drm2E/15+zIlqfF
    iHbDUXJlwwax044W+QeMVpnyIRIFFQkuDtRINtB8BWPU7yBJnsFxbSWCmS5DIK/Q
    LgEhbnP9LqruR69d88uxlGsRSKBQC1bCGwukINgLYo7mKgRbEiw73QMNkHfI8WgE
    l4GruVs4uY8BQ6ldD4SZnn/NQAfUsIwxcNpJZ/i93LaAW6eXc3uyt+q0M8RU6Zs+
    c9gjexwW4GklUdBe3eemcV36XygkTKaceVxo6qmrnMC3wdbOPwmEdTjekFL6TMVw
    771n6X+4R6G14ubQ+JuWchUSEWgHRTl7eHk5oVQvQw3WFlDcpVASuyCRkScqSX/S
    ngGXogBmSG9edwU8HQGkz0zKjLnej07T6F3++pQ+iHMzFAmkrIq28UioGpRd6AaL
    4dMvhlJzilaGJYuwY6CxUV+jwueVl96o8Q7kEkHQyHMXVn08ifieqiNxR0g9l70L
    2OEPTxq1wJUaq/bggivfrDIZsm3lypRBcSwA7OOQ2Gt1ztpFGagTX2zsVVCrHZOa
    LfeuvlabEWC7NjGsX+Vk
    =O+iH
    -----END PGP MESSAGE-----
