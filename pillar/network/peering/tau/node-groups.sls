node_group:
  path_a:
    router_target: [ tauixrt01 ]
    switch_target: [ tauixag01 ]
  path_b:
    router_target: [ tauixrt02 ]
    switch_target: [ tauixag02 ]
  dual_rtr:
    router_target: [ tauixrt01, tauixrt02 ]
    switch_target: [ tauixag01, tauixag02 ]
  local_dev:
    router_target: [ tauixrt01, tauixrt02 ]
    switch_target: [ tauixag01, tauixag02 ]
