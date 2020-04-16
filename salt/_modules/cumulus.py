import json
import time


def cmd_json(cmd):
    try:
        out = json.loads(__salt__["cmd.run"](cmd))
    except:
        return {}
    return out


def bgp_summary():
    data = cmd_json("net show bgp summary json")
    return data


def bgp_graceful_shutdown():
    result = __salt__["cmd.run"](
        'vtysh -c "config t" -c "router bgp" -c "bgp graceful-shutdown" -c "end" -c "wr"'
    )
    return result


def mlag_status():
    data = cmd_json("net show clag status json")
    if len(data) == 0:
        return False
    return data


def mlag_set_priority(priority):
    result = __salt__["cmd.run"]("clagctl priority {}".format(priority))
    time.sleep(5)

    status = mlag_status()
    out = {"stdout": result, "current_status": status}

    if status["status"]["ourPriority"] == priority:
        out["result"] = True
        out["comment"] = "peer priority set"
    else:
        out["result"] = False
        out["comment"] = "peer priority set failed"
    return out


def mlag_graceful_shutdown():
    status = mlag_status()
    out = {"current_status": status}

    # ensure that peer is alive
    if status["status"]["peerAlive"] == False:
        out["result"] = False
        out["comment"] = "cool your jets. peer is not back up"
        return out

    # are we the primary?
    if status["status"]["ourRole"] == "primary":
        peerPriority = status["status"]["peerPriority"]
        if peerPriority >= 65000:
            out["result"] = False
            out["comment"] = "peer priority too high"
            return out

        result = mlag_set_priority(65000)
        if result["result"] == False:
            out["comment"] = "raising clag priority failed"
            out["stdout"] = result["stdout"]
            return out

        status = mlag_status()
        if status["status"]["ourRole"] == "primary":
            out["current_status"] = status
            out["result"] = False
            out["comment"] = "failover to secondary status failed"
            return out

    # peer is alive, we're the secondary - shutdown the clag link.
    result = __salt__["cmd.run"](
        "ip link set {} down".format(status["status"]["peerIf"])
    )
    if result != "":
        out["comment"] = "failed to shutdown clag link"
        out["result"] = False
        out["stdout"] = result

    status = mlag_status()
    out = {"current_status": status, "comment": "mlag shutdown", "result": True}
    return out


def downstream_shutdown(port_glob):
    downstream_status = cmd_json("net show interface {} json".format(port_glob))
    if "iface_obj" in downstream_status: # we've only one matching item in the glob
        if downstream_status["linkstate"].lower() == "up":
            result = __salt__["cmd.run"]("ip link set {} down".format(port_glob))
    else:
        for iface, status in downstream_status.items():
            if status["linkstate"].lower() == "up":
                result = __salt__["cmd.run"]("ip link set {} down".format(iface))

    # recheck downstream state
    time.sleep(5)
    downstream_status = cmd_json("net show interface {} json".format(port_glob))
    shutdown_failed = []
    if "iface_obj" in downstream_status: # we've only one matching item in the glob
        if downstream_status["linkstate"].lower() == "up":
            shutdown_failed.append(iface)
    else:
        for iface, status in downstream_status.items():
            if status["linkstate"].lower() == "up":
                shutdown_failed.append(iface)

    if len(shutdown_failed) != 0:
        return {"result": True, "shutdown_failed": shutdown_failed}
    return {"result": True}


def maintenance_mode(downstream_shut=False, port_glob="swp1-32"):
    # set bgp graceful shutdown
    result = bgp_graceful_shutdown()
    if "[OK]" not in result:
        out = {
            "stdout": result,
            "comment": "failed to set graceful shutdown",
            "result": False,
        }
        return out

    # set mlag graceful shutdown
    if mlag_status() != False:
        result = mlag_graceful_shutdown()
        if result["result"] == False:
            return result

    # shutdown downstream interfaces
    if downstream_shut:
        result = downstream_shutdown(port_glob)
        if result["result"] == False:
            return result

    out = {"comment": "switch is now out of service", "result": True}
    return out
