node_group:
  dual_rtr:
    router_target:
    - shiixrt01
    - shiixrt02
    switch_target:
    - shiixag01
    - shiixag02
  path_a:
    router_target:
    - shiixrt01
    switch_target:
    - shiixag01
  path_b:
    router_target:
    - shiixrt02
    switch_target:
    - shiixag02
  local_dev:
    router_target:
    - shiixrt01
    - shiixrt02
    switch_target:
    - shiixag01
    - shiixag02
    - shi-ce-01
    - shi-ce-02
  local_dev_a:
    router_target:
    - shiixrt01
    switch_target:
    - shiixag01
    - shiixag02
    - shi-ce-01
    - shi-ce-02
  local_dev_b:
    router_target:
    - shiixrt02
    switch_target:
    - shiixag01
    - shiixag02
    - shi-ce-01
    - shi-ce-02
