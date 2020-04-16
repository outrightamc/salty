from jinja2 import Template
import traceback


def mtu_test(size=1600):
    ospf_neighbors = __salt__["napalm.call"]("get_ospf_neighbors")
    results = []
    failed = []
    summary_status = True
    for n in ospf_neighbors["out"]:
        address = n["address"]
        ping_result = __salt__["napalm.call"]("ping2", address, size=size, df=True)

        pass_status = True
        if ("error" in ping_result["out"]) or (
            ping_result["out"]["success"]["packet_loss"]
            == ping_result["out"]["success"]["probes_sent"]
        ):
            pass_status = False
            summary_status = False
            failed.append(n["address"])

        results.append(
            {
                "neighbor": {
                    "address": n["address"],
                    "interface": n["interface"],
                    "neighbor_id": n["neighbor_id"],
                },
                "pass": pass_status,
            }
        )

    return {
        "out": results,
        "result": summary_status,
        "test_size": size,
        "failed": failed,
    }


def ospf_neighbors():
    ospf_neighbors = __salt__["napalm.call"]("get_ospf_neighbors")
    return {"out": ospf_neighbors}


def where_from(prefix, table="inet.0"):
    router_lookup = {
        "185.37.223.16": "atlinet01",
        "185.37.223.17": "atlinet02",
        "185.37.223.22": "ifcinet01",
        "185.37.223.23": "ifcinet02",
        "185.37.223.20": "ld4inet01",
        "185.37.223.21": "pa2inet01",
        "185.37.223.26": "pyrinet01",
        "185.37.223.27": "pyrinet02",
        "185.37.223.31": "sgninet01",
        "185.37.223.18": "shiinet01",
        "185.37.223.19": "shiinet02",
        "185.37.223.24": "sjcinet01",
        "185.37.223.25": "sjcinet02",
    }

    rpc_result = __salt__["napalm.junos_rpc"](
        "get-route-information", destination=prefix, table=table, active_path=True
    )
    if "out" in rpc_result:
        out = {}
        for r in rpc_result["out"]["route-information"]["route-table"]["rt"]:
            dest = r["rt-destination"]
            out[dest] = []
            if isinstance(r["rt-entry"], list):
                for entry in r["rt-entry"]:
                    try:
                        router = router_lookup[str(entry["learned-from"])]
                    except:
                        router = entry["learned-from"]
                    out[dest].append(router)
            else:
                router = r["rt-entry"]["learned-from"]
                try:
                    router = router_lookup[str(r["rt-entry"]["learned-from"])]
                except:
                    router = r["rt-entry"]["learned-from"]
                out[dest].append(router)

        return out
    else:
        return rpc_result


def ospf_cost(circuit_tag, cost, test=False):
    spec = __pillar__["backbone"]["circuits"].get(circuit_tag, False)
    if spec == False:
        raise ValueError("circuit tag not found")

    circuits = spec.get(__grains__["id"], False)
    if circuits == False:
        return

    ios_template = Template(
        """
{%- for intf in circuits %}
interface {{ intf }}
 ip ospf cost {{ cost }}
!
{%- endfor %}
!
end
"""
    )

    junos_template = Template(
        """
{%- for intf in circuits %}
set protocols ospf area 0.0.0.0 interface {{ intf }} metric {{ cost }}
{%- endfor %}
"""
    )

    conf = {"ios": ios_template, "junos": junos_template}

    configuration = conf[__grains__["os"]].render(circuits=circuits, cost=cost)
    out = __salt__["net.load_config"](text=configuration, test=test)
    return out


def no_export_audit():
    hostname = __grains__["id"]
    if "bl" in hostname:
        local_as = "53550"
        instance = "VRF_ARKAD_EXT"
    elif "inet" in hostname:
        local_as = "200077"
        instance = False

    if instance:
        all_peers = __salt__["napalm.junos_rpc"](
            "get_bgp_summary_information", instance=instance
        )
    else:
        all_peers = __salt__["napalm.junos_rpc"]("get_bgp_summary_information")

    ebgp_peers = [
        peer
        for peer in all_peers["out"]["bgp-information"]["bgp-peer"]
        if peer["peer-as"] != local_as
    ]
    neighbor_addresses = [peer["peer-address"] for peer in ebgp_peers]

    out = {"cache_hits":0}
    route_lookup_cache = {}

    for n in neighbor_addresses:
        reply = __salt__["napalm.junos_rpc"](
            "get_route_information",
            advertising_protocol_name="bgp",
            protocol="bgp",
            active_path=True,
            neighbor=n,
            community_name="COMM_ARKAD_BBONE",
        )

        out[n] = {}
        try:
            if "route-table" in reply["out"]["route-information"]:
                if "rt" in reply["out"]["route-information"]["route-table"]:
                    routes = reply["out"]["route-information"]["route-table"]["rt"]

                    if isinstance(routes, list):
                        destinations = [r["rt-destination"] for r in routes]
                    else:
                        destinations = [routes["rt-destination"]]

                        for r in destinations:
                            cached = route_lookup_cache.get(r, False)
                            if cached == False:
                                reply = __salt__["napalm.junos_rpc"](
                                    "get_route_information",
                                    protocol="bgp",
                                    destination=r,
                                )
                                route_info = reply["out"]["route-information"][
                                    "route-table"
                                ]["rt"]

                                route_lookup_cache[r] = route_info
                                out[n][r] = route_info
                            else:
                                out[n][r] = cached
                                out["cache_hits"] += 1
        except:
            out[n]["traceback"] = traceback.format_exc()
            out[n]["rpc_reply"] = reply
    return out
