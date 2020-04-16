import netaddr


def _new_logical_interface(
    address,
    description,
    vlan,
    sample=False,
    vrrp=False,
    group=1,
    virtual_address="",
    priority=100,
    bfd=False,
    bandwidth=0,
):
    logical_unit = {
        "description": description,
        "vlan_id": vlan,
        "family": {"inet": {"address": [{"prefix": address}]}},
    }

    if vrrp:
        if virtual_address == "":
            raise ValueError("vrrp specified but virtual_address is not set")
        logical_unit["family"]["inet"]["address"][0]["vrrp_group"] = [
            {"address": virtual_address, "group": group, "priority": priority}
        ]

    if bandwidth != 0:
        logical_unit["bandwidth"] = bandwidth

    if sample:
        logical_unit["family"]["inet"]["sampling"] = {"input": True, "output": True}

    if bfd:
        logical_unit["bfd"] = {}

    return logical_unit


def _get_bgp_policy(name, imp, exp, pref, version, state="present"):
    name = name.upper()
    set_lpref = [{"type": "local-preference", "value": 200}]
    set_aspp = [{"type": "as-path-prepend", "value": "53550 53550"}]

    if pref not in ["primary", "standby", ""]:
        if __grains__["id"] == pref:
            pref = "primary"
        else:
            pref = "standby"

    import_policy = _policy_naming(name, "inbound", version)
    export_policy = _policy_naming(name, "outbound", version)

    import_list = _prefix_list_naming(name, "inbound", version)
    export_list = _prefix_list_naming(name, "outbound", version)

    policy_options = {
        "prefix_list": {
            import_list: {"state": state, "term": imp},
            export_list: {"state": state, "term": exp},
        },
        "policy_statement": {
            import_policy: {
                "state": state,
                "term": [
                    {
                        "name": 1,
                        "match": [{"type": "prefix-list", "value": import_list}],
                        "action": set_lpref if pref == "primary" else [],
                    }
                ],
            },
            export_policy: {
                "state": state,
                "term": [
                    {
                        "name": 1,
                        "match": [{"type": "prefix-list", "value": export_list}],
                        "action": set_aspp if pref == "standby" else [],
                    }
                ],
            },
        },
    }

    return policy_options


def _new_switchport(tagged=True):
    mode = "access"
    if tagged:
        mode = "trunk"

    return {
        "unit": {
            "0": {
                "state": "present",
                "family": {
                    "ethernet_switching": {
                        "interface_mode": mode,
                        "vlan": {"members": []},
                    }
                },
            }
        }
    }


def _add_vlan_member(port, vlan):
    members = port["unit"]["0"]["family"]["ethernet_switching"]["vlan"]["members"]
    members.append(vlan)
    return


def _ip_allocate(subnet, node_index, num_gw=2, vrrp=False, reverse=False):
    if len(subnet) > 2:
        hosts = [str(ip) for ip in subnet[1:-1]]
    else:
        # assuming a /31
        hosts = [str(ip) for ip in subnet]

    va = None
    try:
        if reverse:
            if vrrp:
                va = hosts.pop(0)
            gateways = hosts[:num_gw]
            remaining = hosts[num_gw:]
            peer_index = len(remaining) - 1
        else:
            if vrrp:
                va = hosts.pop()
            gateways = hosts[num_gw * -1 :]
            remaining = hosts[: num_gw * -1]
            peer_index = 0
        la = gateways[node_index - 1]
    except IndexError:
        raise ValueError("supplied subnet is not large enough")

    if len(remaining) == 0:
        raise ValueError("supplied subnet is not large enough")

    allocation = {
        "local_address": la,
        "virtual_address": va,
        "host_addresses": remaining,
        "peer_index": peer_index,
    }

    return allocation


def _filter_vlan(vlan, current_vlans):
    for v in current_vlans:
        if int(v["vlan_id"]) == vlan:
            return v
    return None


def _vlan_naming(type_code, peering_id, short_name, vlan_id, version):
    if version == 1:
        return "{}-{}-{}".format(type_code, peering_id, short_name).upper()
    elif version == 2:
        dc = __grains__["id"][:3]
        company_tag = peering_id.split("_")[1]
        return "VL_{dc}_{vlan_id}_{tag}-{short_name}".format(
            dc=dc, vlan_id=vlan_id, tag=company_tag, short_name=short_name
        ).upper()


def _prefix_list_naming(peering_id, direction, version):
    if version == 1:
        if direction == "inbound":
            code = "IM"
        elif direction == "outbound":
            code = "EX"

        return "PFX_{}_{}".format(peering_id, code)
    elif version == 2:
        if direction == "inbound":
            code = "IMP"
        elif direction == "outbound":
            code = "EXP"

        company_tag = peering_id.split("_")[1]
        return "PFX_{dir_code}_{tag}-BGP_V4".format(
            dir_code=code, tag=company_tag
        ).upper()


def _policy_naming(peering_id, direction, version):
    if version == 1:
        if direction == "inbound":
            code = "IM"
        elif direction == "outbound":
            code = "EX"

        return "POL_{}_{}".format(peering_id, code).upper()
    elif version == 2:
        if direction == "inbound":
            code = "IMP"
        elif direction == "outbound":
            code = "EXP"

        company_tag = peering_id.split("_")[1]
        return "RM_{dir_code}_{tag}-BGP_V4".format(
            dir_code=code, tag=company_tag
        ).upper()


def _switch_add_peer(peering, topology, device_code_map):
    version = peering.get("version", 1)

    cp = {"interface": {}, "vlan": {}}
    int_dict = cp["interface"]

    # safety check for vlan id, needs junos implementation.
    if __grains__["os"] == "ios":
        current_vlans = __salt__["iosutil.show_vlan"]()["out"]["show vlan"]
    else:
        current_vlans = []

    node_group = __pillar__["node_group"][peering["local"]["node_group"]][
        "switch_target"
    ]
    if __grains__["id"] in node_group:
        type_code = device_code_map[peering["local"]["device"]]
        short_name = topology["connected_devices"][peering["local"]["device"]][
            "short_name"
        ]
        vlan_name = _vlan_naming(
            type_code, peering["id"], short_name, peering["local"]["vlan"], version
        )

        # does this vlan already exist under a different name?
        vlan_current = _filter_vlan(peering["local"]["vlan"], current_vlans)
        if vlan_current is not None:
            if vlan_current["name"].lower() != vlan_name.lower():
                raise ValueError(
                    "{}: vlan {} already exists under a different name: {}".format(
                        peering["id"], peering["local"]["vlan"], vlan_current["name"]
                    )
                )

        cp["vlan"] = {
            peering["local"]["vlan"]: {"state": "present", "name": vlan_name.upper()}
        }

        for i in (
            topology["connected_devices"]
            .get(peering["local"]["device"], {})
            .get("tagged_interfaces", [])
        ):
            if i not in int_dict:
                int_dict[i] = _new_switchport()
            _add_vlan_member(int_dict[i], int(peering["local"]["vlan"]))

    for ix in peering["ix_group"]:
        node_group = __pillar__["node_group"][ix["node_group"]]
        if __grains__["id"] in node_group["switch_target"]:
            vlan_name = _vlan_naming("E", peering["id"], "IX", ix["vlan"], version)

            # does this vlan already exist under a different name?
            vlan_current = _filter_vlan(ix["vlan"], current_vlans)
            if vlan_current is not None:
                if vlan_current["name"].lower() != vlan_name.lower():
                    raise ValueError(
                        "{}: vlan {} already exists under a different name: {}".format(
                            peering["id"], ix["vlan"], vlan_current["name"]
                        )
                    )

            cp["vlan"][ix["vlan"]] = {"state": "present", "name": vlan_name}
            for i in topology["connected_devices"]["external_peer"][
                "tagged_interfaces"
            ]:
                if i not in int_dict:
                    int_dict[i] = _new_switchport()
                _add_vlan_member(int_dict[i], int(ix["vlan"]))

            # if two routers are involved then we also need to trunk the ix port
            # to the other router.
            if len(node_group["router_target"]) > 1:
                for i in topology["connected_devices"]["federated_ixrt"][
                    "tagged_interfaces"
                ]:
                    if i not in int_dict:
                        int_dict[i] = _new_switchport()
                    _add_vlan_member(int_dict[i], int(ix["vlan"]))

            # check to see if we need to add an access port for the peering
            for access_port in ix["connection"]:
                if access_port["switch"] == __grains__["id"]:
                    # safety check, is this port already allocated?
                    current_interfaces = __salt__["net.interfaces"]()["out"]
                    interface = current_interfaces.get(access_port["port"], None)
                    if interface is None:
                        raise ValueError(
                            """{}: couldn't find specified access port {}""".format(
                                peering["id"], access_port["port"]
                            )
                        )

                    current_description = interface["description"]
                    check_description = access_port.get(
                        "check_override", peering["id"].lower()
                    )
                    if check_description not in current_description.lower():
                        raise ValueError(
                            """{}: peering ID not found in access port description: {}""".format(
                                peering["id"], current_description
                            )
                        )

                    i = access_port["port"]
                    int_dict[i] = _new_switchport(
                        tagged=access_port.get("tagged", False)
                    )
                    int_dict[i]["unit"]["0"]["description"] = "E:{}:{}:IX".format(
                        peering["id"], access_port.get("circuit_id", "")
                    ).upper()
                    _add_vlan_member(int_dict[i], int(ix["vlan"]))
    return cp


def _switch_rm_peer(peering, topology, device_code_map):
    version = peering.get("version", 1)

    cp = {"interface": {}, "vlan": {}}
    int_dict = cp["interface"]

    node_group = __pillar__["node_group"][peering["local"]["node_group"]][
        "switch_target"
    ]
    if __grains__["id"] in node_group:
        type_code = device_code_map[peering["local"]["device"]]
        short_name = topology["connected_devices"][peering["local"]["device"]][
            "short_name"
        ]
        vlan_name = _vlan_naming(
            type_code, peering["id"], short_name, peering["local"]["vlan"], version
        )

        cp["vlan"] = {
            peering["local"]["vlan"]: {"state": "absent", "name": vlan_name.upper()}
        }

        for i in (
            topology["connected_devices"]
            .get(peering["local"]["device"], {})
            .get("tagged_interfaces", [])
        ):
            if i not in int_dict:
                int_dict[i] = _new_switchport()
            _add_vlan_member(int_dict[i], int(peering["local"]["vlan"]))

    for ix in peering["ix_group"]:
        node_group = __pillar__["node_group"][ix["node_group"]]
        if __grains__["id"] in node_group["switch_target"]:
            # remove vlan definition
            vlan_name = _vlan_naming("E", peering["id"], "IX", ix["vlan"], version)
            cp["vlan"][ix["vlan"]] = {"state": "absent", "name": vlan_name}

            # remove access port
            for access_port in ix["connection"]:
                if access_port["switch"] == __grains__["id"]:
                    i = access_port["port"]
                    if i not in int_dict:
                        int_dict[i] = _new_switchport(tagged=False)
                        int_dict[i]["unit"]["0"] = {"state": "absent"}

            # remove vlan from trunk ports
            for i in topology["connencted_devices"]["external_peer"][
                "tagged_interfaces"
            ]:
                if i not in int_dict:
                    int_dict[i] = _new_switchport()
                _add_vlan_member(int_dict[i], int(ix["vlan"]))

            if len(node_group["router_target"]) > 1:
                for i in topology["connected_devices"]["federated_ixrt"][
                    "tagged_interfaces"
                ]:
                    if i not in int_dict:
                        int_dict[i] = _new_switchport()
                    _add_vlan_member(int_dict[i], int(ix["vlan"]))
    return cp


def _router_add_peer(peering, topology, device_code_map):
    version = peering.get("version", 1)

    rd_allocation = peering["routing"]["vrf"].get("allocation_type", "legacy")
    if rd_allocation == "legacy":
        rd = peering["routing"]["vrf"]["rd"]
        rt = peering["routing"]["vrf"]["rt"]
    elif rd_allocation == "unique":
        rd = "{}:{}".format(topology["mpls_loopback"], peering["routing"]["vrf"]["id"])
        rt = "{}:{}".format("53550", peering["routing"]["vrf"]["id"])

    cp = {
        "interface": {},
        "routing_instances": {
            peering["id"]: {
                "state": "present",
                "description": peering["description"],
                "instance_type": "vrf",
                "vrf": {"route_distinguisher": rd, "route_target": rt},
                "protocols": {},
                "interfaces": [],
            }
        },
    }

    # set up some dict shorthand
    ri = cp["routing_instances"][peering["id"]]
    int_dict = cp["interface"]
    ri_ints = ri["interfaces"]
    proto_dict = ri["protocols"]

    # safety check. get list of current interfaces to check for re-use.
    current_interfaces = __salt__["net.interfaces"]()["out"]

    node_group = __pillar__["node_group"][peering["local"]["node_group"]][
        "router_target"
    ]
    if __grains__["id"] in node_group:
        vrrp = False
        if len(node_group) > 1:
            vrrp = True

        node_index = node_group.index(__grains__["id"]) + 1
        local_subnet = netaddr.IPNetwork(peering["local"]["network"])
        local_allocation = _ip_allocate(
            local_subnet, node_index, num_gw=len(node_group), vrrp=vrrp
        )
        local_address = local_allocation["local_address"]
        virtual_address = local_allocation["virtual_address"]

        # add sbc/fw/etc facing interface
        for i in (
            topology["connected_devices"]
            .get(peering["local"]["device"], {})
            .get("tagged_interfaces", [])
        ):
            if i not in int_dict:
                int_dict[i] = {"vlan_tagging": True, "unit": {}}

            type_code = device_code_map[peering["local"]["device"]]
            short_name = topology["connected_devices"][peering["local"]["device"]][
                "short_name"
            ]
            description = "{}:{}_{}".format(
                type_code, peering["id"], short_name
            ).upper()
            priority = 200 - (topology["node_index"] * 50)

            # does the interface already exist under a different name?
            subint_name = i + "." + str(peering["local"]["vlan"])
            current_interface = current_interfaces.get(subint_name, None)
            if current_interface is not None:
                if (
                    current_interface["description"].lower().strip('"')
                    != description.lower()
                ):
                    raise ValueError(
                        "{}: interface {} already exists with different description: {}".format(
                            peering["id"], subint_name, current_interface["description"]
                        )
                    )

            int_dict[i]["unit"][str(peering["local"]["vlan"])] = _new_logical_interface(
                address="{}/{}".format(local_address, local_subnet.prefixlen),
                description=description,
                vlan=peering["local"]["vlan"],
                sample=False,
                vrrp=vrrp,
                virtual_address=virtual_address,
                priority=priority,
            )
            ri_ints.append("{}.{}".format(i, peering["local"]["vlan"]))

    for ix in peering["ix_group"]:
        node_group = __pillar__["node_group"][ix["node_group"]]
        if __grains__["id"] in node_group["router_target"]:
            peering_subnet = netaddr.IPNetwork(ix["network"])
            node_index = node_group["router_target"].index(__grains__["id"]) + 1
            allocation = _ip_allocate(
                peering_subnet,
                node_index,
                num_gw=len(node_group["router_target"]),
                vrrp=ix.get("vrrp", False),
                reverse=ix.get("reverse_ip", False),
            )
            neighbor_addr = allocation["host_addresses"].pop(allocation["peer_index"])
            local_address = allocation["local_address"]
            virtual_address = allocation["virtual_address"]

            # add ix facing interface
            for i in topology["connected_devices"]["external_peer"][
                "tagged_interfaces"
            ]:
                if i not in int_dict:
                    int_dict[i] = {"vlan_tagging": True, "unit": {}}

                description = "E:{}_IX".format(peering["id"]).upper()

                # does the interface already exist under a different name?
                subint_name = i + "." + str(ix["vlan"])
                current_interface = current_interfaces.get(subint_name, None)
                if current_interface is not None:
                    if current_interface["description"].strip('"') != description:
                        raise ValueError(
                            "{}: interface {} already exists with different description: {}: expected {}".format(
                                peering["id"],
                                subint_name,
                                current_interface["description"],
                                description,
                            )
                        )

                if virtual_address is not None:
                    priority = 200 - (node_index * 50)

                    int_dict[i]["unit"][str(ix["vlan"])] = _new_logical_interface(
                        address="{}/{}".format(local_address, peering_subnet.prefixlen),
                        description=description,
                        vlan=ix["vlan"],
                        bfd=ix.get("bfd", False),
                        vrrp=True,
                        virtual_address=virtual_address,
                        priority=priority,
                        bandwidth=ix.get("bandwidth", 0),
                    )
                else:
                    int_dict[i]["unit"][str(ix["vlan"])] = _new_logical_interface(
                        address="{}/{}".format(local_address, peering_subnet.prefixlen),
                        description=description,
                        vlan=ix["vlan"],
                        bfd=ix.get("bfd", False),
                        bandwidth=ix.get("bandwidth", 0),
                    )
                ri_ints.append("{}.{}".format(i, ix["vlan"]))

            # set up routing
            # add any static routes
            if "static" in peering["routing"]:
                proto_dict["static"] = {}
                for s in peering["routing"]["static"]:
                    if "next_hop" in s:
                        next_hop = s["next_hop"]
                    else:
                        next_hop = neighbor_addr

                    proto_dict["static"][s["network"]] = {"next_hop": next_hop}

            # add any bgp routing
            if "bgp" in peering["routing"]:
                custom_policies = peering["routing"]["bgp"].get("custom_policy", False)
                if custom_policies:
                    import_policy = custom_policies["import"]
                    export_policy = custom_policies["export"]
                else:
                    export = [peering["local"]["network"]]
                    if "export_filter_append" in peering["routing"]["bgp"]:
                        export += peering["routing"]["bgp"]["export_filter_append"]
                    if "static" in peering["routing"]:
                        for s in peering["routing"]["static"]:
                            if "next_hop" not in s:
                                export.append(s["network"])
                    cp["policy_options"] = _get_bgp_policy(
                        peering["id"],
                        peering["routing"]["bgp"]["import_filter"],
                        export,
                        ix.get("preference", ""),
                        version,
                    )
                    import_policy = _policy_naming(peering["id"], "inbound", version)
                    export_policy = _policy_naming(peering["id"], "outbound", version)

                # retrieve timer configuration
                if "timers" in peering["routing"]["bgp"]:
                    hello = peering["routing"]["bgp"]["timers"]["keep_alive"]
                    hold = peering["routing"]["bgp"]["timers"]["hold_down"]
                else:
                    hello = 2
                    hold = 6

                proto_dict["bgp"] = {
                    "redistribute": ["connected", "static"],
                    "group": {
                        "EXTERNAL": {
                            "description": "external customer peerings",
                            "remote_as": peering["routing"]["bgp"]["asn"],
                            "type": "external",
                            "import": import_policy,
                            "export": export_policy,
                            "timers": {"hello": hello, "hold": hold},
                            "neighbor": [{"address": neighbor_addr}],
                        }
                    },
                }

                if "password" in peering["routing"]["bgp"]:
                    password = peering["routing"]["bgp"]["password"]
                    proto_dict["bgp"]["group"]["EXTERNAL"]["password"] = password

                if "bfd" in ix:
                    proto_dict["bgp"]["group"]["EXTERNAL"]["bfd"] = {}
    return cp


def _router_rm_peer(peering, topology, device_code_map):
    version = peering.get("version", 1)

    cp = {
        "interface": {},
        "routing_instances": {
            peering["id"]: {"state": "absent", "instance_type": "vrf", "interfaces": []}
        },
    }

    # set up some dict shorthand
    ri = cp["routing_instances"][peering["id"]]
    int_dict = cp["interface"]
    ri_ints = ri["interfaces"]

    node_group = __pillar__["node_group"][peering["local"]["node_group"]][
        "router_target"
    ]
    if __grains__["id"] in node_group:
        # set interfaces to absent state
        for i in (
            topology["connected_devices"]
            .get(peering["local"]["device"], {})
            .get("tagged_interfaces", [])
        ):
            if i not in int_dict:
                int_dict[i] = {"vlan_tagging": True, "unit": {}}
            int_dict[i]["unit"][peering["local"]["vlan"]] = {"state": "absent"}
            ri_ints.append("{}.{}".format(i, peering["local"]["vlan"]))

    for ix in peering["ix_group"]:
        node_group = __pillar__["node_group"][ix["node_group"]]
        if __grains__["id"] in node_group["router_target"]:
            if "bgp" in peering["routing"]:
                custom_policies = peering["routing"]["bgp"].get("custom_policy", False)
                if not custom_policies:
                    cp["policy_options"] = _get_bgp_policy(
                        peering["id"],
                        [],
                        [],
                        ix.get("preference", ""),
                        version,
                        state="absent",
                    )

            for i in topology["connected_devices"]["external_peer"][
                "tagged_interfaces"
            ]:
                if i not in int_dict:
                    int_dict[i] = {"vlan_tagging": True, "unit": {}}
                int_dict[i]["unit"][ix["vlan"]] = {"state": "absent"}
                ri_ints.append("{}.{}".format(i, ix["vlan"]))
    return cp


def private_peering():
    peerings = __pillar__.get("peerings", [])
    if len(peerings) == 0:
        return {}

    roles = __pillar__.get("roles", [])
    switch = False
    router = False
    if "edge_switch" in roles:
        switch = True
    if "mpls_pe" in roles:
        router = True
    if router == switch:
        raise ValueError("peering role error")

    topology = __pillar__.get("topology", False)
    if not topology:
        raise ValueError("peering topology undefined")

    device_code_map = {"edge_firewall": "F", "customer_sbc": "V", "carrier_sbc": "V"}

    compiled_peerings = []
    for p in peerings:
        if switch:
            if p["state"] == "present":
                cp = _switch_add_peer(p, topology, device_code_map)
            elif p["state"] == "absent":
                cp = _switch_rm_peer(p, topology, device_code_map)
        elif router:
            if p["state"] == "present":
                cp = _router_add_peer(p, topology, device_code_map)
            elif p["state"] == "absent":
                cp = _router_rm_peer(p, topology, device_code_map)
        compiled_peerings.append(cp)

    merged = {}
    for cp in compiled_peerings:
        merged = __salt__["slsutil.merge"](merged, cp, merge_lists=True)
    return merged
