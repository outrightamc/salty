node_group:
  path_a:
    router_target: [ pyrixrt01 ]
    switch_target: [ pyrixag01 ]
  path_b:
    router_target: [ pyrixrt02 ]
    switch_target: [ pyrixag02 ]
  dual_rtr:
    router_target: [ pyrixrt01, pyrixrt02 ]
    switch_target: [ pyrixag01, pyrixag02 ]
  local_dev:
    router_target: [ pyrixrt01, pyrixrt02 ]
    switch_target: [ pyrixag01, pyrixag02 ]
