from __future__ import unicode_literals
from napalm.junos.junos import JunOSDriver

# import stdlib
import re
import json
import logging
import collections
from copy import deepcopy
from collections import OrderedDict, defaultdict

# import third party lib
from lxml.builder import E
from lxml import etree

from jnpr.junos import Device
from jnpr.junos.utils.config import Config
from jnpr.junos.exception import RpcError
from jnpr.junos.exception import ConfigLoadError
from jnpr.junos.exception import RpcTimeoutError
from jnpr.junos.exception import ConnectTimeoutError
from jnpr.junos.exception import LockError as JnprLockError
from jnpr.junos.exception import UnlockError as JnrpUnlockError

# import NAPALM Base
import napalm.base.helpers
from napalm.base.base import NetworkDriver
from napalm.base.utils import py23_compat
from napalm.junos import constants as C
from napalm.base.exceptions import ConnectionException
from napalm.base.exceptions import MergeConfigException
from napalm.base.exceptions import CommandErrorException
from napalm.base.exceptions import ReplaceConfigException
from napalm.base.exceptions import CommandTimeoutException
from napalm.base.exceptions import LockError
from napalm.base.exceptions import UnlockError

# import local modules
from napalm.junos.utils import junos_views

log = logging.getLogger(__file__)


class CustomJunOSDriver(JunOSDriver):
    def test_custom(self):
        return {'custom_driver': True}


    def get_ospf_neighbors(self):
        raw_ospf_output = self.device.rpc.get_ospf_neighbor_information()
        ospf_neighbors = []
        for n in raw_ospf_output:
            ospf_neighbors.append({
                "address": n.find(".//neighbor-address").text,
                "dead_time": n.find(".//activity-timer").text,
                "interface": n.find(".//interface-name").text,
                "neighbor_id": n.find(".//neighbor-id").text,
                "priority": n.find(".//neighbor-priority").text,
                "state": n.find(".//ospf-neighbor-state").text,
            })
        return ospf_neighbors


    def ping2(
        self,
        destination,
        source=C.PING_SOURCE,
        ttl=C.PING_TTL,
        timeout=C.PING_TIMEOUT,
        size=C.PING_SIZE,
        count=C.PING_COUNT,
        vrf=C.PING_VRF,
        df=False,
    ):

        ping_dict = {}

        source_str = ""
        maxttl_str = ""
        timeout_str = ""
        size_str = ""
        count_str = ""
        vrf_str = ""

        if source:
            source_str = " source {source}".format(source=source)
        if ttl:
            maxttl_str = " ttl {ttl}".format(ttl=ttl)
        if timeout:
            timeout_str = " wait {timeout}".format(timeout=timeout)
        if size:
            size_str = " size {size}".format(size=size)
        if count:
            count_str = " count {count}".format(count=count)
        if vrf:
            vrf_str = " routing-instance {vrf}".format(vrf=vrf)

        ping_command = "ping {destination}{source}{ttl}{timeout}{size}{count}{vrf}".format(
            destination=destination,
            source=source_str,
            ttl=maxttl_str,
            timeout=timeout_str,
            size=size_str,
            count=count_str,
            vrf=vrf_str,
        )
        if df is True:
            ping_command += " do-not-fragment"

        ping_rpc = E("command", ping_command)
        rpc_reply = self.device._conn.rpc(ping_rpc)._NCElement__doc
        # make direct RPC call via NETCONF
        probe_summary = rpc_reply.find(".//probe-results-summary")

        if probe_summary is None:
            rpc_error = rpc_reply.find(".//rpc-error")
            return {
                "error": "{}".format(
                    napalm.base.helpers.find_txt(rpc_error, "error-message")
                )
            }

        packet_loss = napalm.base.helpers.convert(
            int, napalm.base.helpers.find_txt(probe_summary, "packet-loss"), 100
        )

        # rtt values are valid only if a we get an ICMP reply
        if packet_loss != 100:
            ping_dict["success"] = {}
            ping_dict["success"]["probes_sent"] = int(
                probe_summary.findtext("probes-sent")
            )
            ping_dict["success"]["packet_loss"] = packet_loss
            ping_dict["success"].update(
                {
                    "rtt_min": round(
                        (
                            napalm.base.helpers.convert(
                                float,
                                napalm.base.helpers.find_txt(
                                    probe_summary, "rtt-minimum"
                                ),
                                -1,
                            )
                            * 1e-3
                        ),
                        3,
                    ),
                    "rtt_max": round(
                        (
                            napalm.base.helpers.convert(
                                float,
                                napalm.base.helpers.find_txt(
                                    probe_summary, "rtt-maximum"
                                ),
                                -1,
                            )
                            * 1e-3
                        ),
                        3,
                    ),
                    "rtt_avg": round(
                        (
                            napalm.base.helpers.convert(
                                float,
                                napalm.base.helpers.find_txt(
                                    probe_summary, "rtt-average"
                                ),
                                -1,
                            )
                            * 1e-3
                        ),
                        3,
                    ),
                    "rtt_stddev": round(
                        (
                            napalm.base.helpers.convert(
                                float,
                                napalm.base.helpers.find_txt(
                                    probe_summary, "rtt-stddev"
                                ),
                                -1,
                            )
                            * 1e-3
                        ),
                        3,
                    ),
                }
            )

            tmp = rpc_reply.find(".//ping-results")

            results_array = []
            for probe_result in tmp.findall("probe-result"):
                ip_address = napalm.base.helpers.convert(
                    napalm.base.helpers.ip,
                    napalm.base.helpers.find_txt(probe_result, "ip-address"),
                    "*",
                )

                rtt = round(
                    (
                        napalm.base.helpers.convert(
                            float, napalm.base.helpers.find_txt(probe_result, "rtt"), -1
                        )
                        * 1e-3
                    ),
                    3,
                )

                results_array.append({"ip_address": ip_address, "rtt": rtt})

            ping_dict["success"].update({"results": results_array})
        else:
            return {"error": "Packet loss {}".format(packet_loss)}

        return ping_dict

