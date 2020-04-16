import netscreen
import traceback
import re


def list_matches(tgt):
    tgt_re = re.compile(tgt)
    netscreens = __pillar__.get("netscreens", [])
    matches = [host for host in netscreens if tgt_re.match(host)]
    return matches


def cli(tgt, cmd, save=False):
    username = __salt__["pillar.get"]("proxy:username")
    password = __salt__["pillar.get"]("proxy:passwd")
    netscreens = list_matches(tgt)

    out = {}
    for host in netscreens:
        out[host] = {}
        try:
            with netscreen.ScreenOS(host, username, password) as ns:
                out[host]["output"] = ns.send(cmd)
                if save:
                    ns.send("save")
        except:
            out[host]["traceback"] = traceback.format_exc()
    return out


def get_blacklist(tgt):
    reply = cli(tgt, "get group address untrust PFX_BLACKLIST_V4")
    out = {}
    for host, data in reply.items():
        try:
            if "traceback" in data:
                out[host] = { "traceback": data["traceback"] }
            else:
                members = data["output"][0].splitlines()[2].strip().split(" ")[1:]
                out[host] = {
                    "members": [ m.strip('"') for m in members ]
                }
        except IndexError:
            out[host] = { "members": [] }
    return out
