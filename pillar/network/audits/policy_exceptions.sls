policy_exceptions:
  acl:
    - {minion: 'tau-vpn-01', from: 'SHARED_DMZ', to: 'INET_BDR_INTERCO', name: 'ACL_SHARED_DMZ_TO_INET_BDR_INTERCO' }
    - {minion: 'pyr-fw-01', from: 'SHARED_DMZ', to: 'INET_BDR_INTERCO', name: 'ACL_SHARED_DMZ_TO_INET_BDR_INTERCO' }