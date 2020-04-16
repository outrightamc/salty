netscreen_blacklist_managed:
  netscreen.blacklist_managed:
    - tgt: '.*'
    - blacklist: {{ salt.pillar.get('blacklisted_ips', []) }}
