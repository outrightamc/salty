node_group:
  path_a:
    router_target: [ ld4ixrt01 ]
    switch_target: [ ld4-lf-01, ld4ixag01 ]
  path_b:
    router_target: [ ld4ixrt02 ]
    switch_target: [ ld4-lf-02, ld4ixag02 ]
  dual_rtr:
    router_target: [ ld4ixrt01, ld4ixrt02 ]
    switch_target: [ ld4-lf-01, ld4-lf-02, ld4ixag01, ld4ixag02 ]
  local_dev:
    router_target: [ ld4ixrt01, ld4ixrt02 ]
    switch_target: [ ld4ixag01, ld4ixag02 ]
