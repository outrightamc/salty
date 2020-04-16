node_group:
  dual_rtr:
    router_target:
    - atlixrt01
    - atlixrt02
    switch_target:
    - atlixag01
    - atlixag02
  local_dev:
    router_target:
    - atlixrt01
    - atlixrt02
    switch_target:
    - atlixag01
    - atlixag02
  path_a:
    router_target:
    - atlixrt01
    switch_target:
    - atlixag02
  path_b:
    router_target:
    - atlixrt02
    switch_target:
    - atlixag01

