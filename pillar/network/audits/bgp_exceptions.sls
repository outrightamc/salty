bgp_exceptions:
  peer:
    - { minion: 'atlinet01', routing_table: 'global', ASN: '200077', remote_address: '192.206.95.169' }
    - { minion: 'chi-ce-02', routing_table: 'VRF_BRDSFT_SIP', ASN: '21534', remote_address: '10.0.66.2' }
    - { minion: 'atlixrt01', routing_table: 'VRF_MCC_108', ASN: '18486', remote_address: '172.16.14.41' }
    - { minion: 'atlixrt02', routing_table: 'VRF_MCC_108', ASN: '18486', remote_address: '172.16.14.45' }