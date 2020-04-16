from napalm.ios.ios import IOSDriver
from collections import defaultdict
import napalm.base.helpers
import napalm.base.constants as C
from napalm.base.utils import py23_compat
import copy
import re

# Easier to store these as constants
HOUR_SECONDS = 3600
DAY_SECONDS = 24 * HOUR_SECONDS
WEEK_SECONDS = 7 * DAY_SECONDS
YEAR_SECONDS = 365 * DAY_SECONDS

# STD REGEX PATTERNS
IP_ADDR_REGEX = r"\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}"
IPV4_ADDR_REGEX = IP_ADDR_REGEX
IPV6_ADDR_REGEX_1 = r"::"
IPV6_ADDR_REGEX_2 = r"[0-9a-fA-F:]{1,39}::[0-9a-fA-F:]{1,39}"
IPV6_ADDR_REGEX_3 = r"[0-9a-fA-F]{1,4}:[0-9a-fA-F]{1,4}:[0-9a-fA-F]{1,4}:[0-9a-fA-F]{1,4}:" \
                             "[0-9a-fA-F]{1,4}:[0-9a-fA-F]{1,4}:[0-9a-fA-F]{1,4}:[0-9a-fA-F]{1,4}"
# Should validate IPv6 address using an IP address library after matching with this regex
IPV6_ADDR_REGEX = "(?:{}|{}|{})".format(IPV6_ADDR_REGEX_1, IPV6_ADDR_REGEX_2, IPV6_ADDR_REGEX_3)

MAC_REGEX = r"[a-fA-F0-9]{4}\.[a-fA-F0-9]{4}\.[a-fA-F0-9]{4}"
VLAN_REGEX = r"\d{1,4}"
INT_REGEX = r"(^\w{1,2}\d{1,3}/\d{1,2}|^\w{1,2}\d{1,3})"
RE_IPADDR = re.compile(r"{}".format(IP_ADDR_REGEX))
RE_IPADDR_STRIP = re.compile(r"({})\n".format(IP_ADDR_REGEX))
RE_MAC = re.compile(r"{}".format(MAC_REGEX))

# Period needed for 32-bit AS Numbers
ASN_REGEX = r"[\d\.]+"

AFI_COMMAND_MAP = {
    'IPv4 Unicast': 'ipv4 unicast',
    'IPv6 Unicast': 'ipv6 unicast',
    'VPNv4 Unicast': 'vpnv4 all',
    'VPNv6 Unicast': 'vpnv6 unicast all',
    'IPv4 Multicast': 'ipv4 multicast',
    'IPv6 Multicast': 'ipv6 multicast',
    'L2VPN E-VPN': 'l2vpn evpn',
    'MVPNv4 Unicast': 'ipv4 mvpn all',
    'MVPNv6 Unicast': 'ipv6 mvpn all',
    'VPNv4 Flowspec': 'ipv4 flowspec',
    'VPNv6 Flowspec': 'ipv6 flowspec',
}


class CustomIOSDriver(IOSDriver):
    def test_custom(self):
        return {'custom_driver': True}


    def get_ospf_neighbors(self):
        raw_ospf_output = self._send_command('show ip ospf neighbor').strip()
        ospf_neighbors = napalm.base.helpers.textfsm_extractor(
            self, 'ip_ospf_neighbors', raw_ospf_output)
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
        """
        Execute ping on the device and returns a dictionary with the result.

        Output dictionary has one of following keys:
            * success
            * error
        In case of success, inner dictionary will have the followin keys:
            * probes_sent (int)
            * packet_loss (int)
            * rtt_min (float)
            * rtt_max (float)
            * rtt_avg (float)
            * rtt_stddev (float)
            * results (list)
        'results' is a list of dictionaries with the following keys:
            * ip_address (str)
            * rtt (float)
        """
        ping_dict = {}
        # vrf needs to be right after the ping command
        if vrf:
            command = "ping vrf {} {}".format(vrf, destination)
        else:
            command = "ping {}".format(destination)
        command += " timeout {}".format(timeout)
        command += " size {}".format(size)
        command += " repeat {}".format(count)
        if df is True:
            command += " df-bit"
        if source != "":
            command += " source {}".format(source)

        output = self._send_command(command)
        if "%" in output:
            ping_dict["error"] = output
        elif "Sending" in output:
            ping_dict["success"] = {
                "probes_sent": 0,
                "packet_loss": 0,
                "rtt_min": 0.0,
                "rtt_max": 0.0,
                "rtt_avg": 0.0,
                "rtt_stddev": 0.0,
                "results": [],
            }

            for line in output.splitlines():
                if "Success rate is" in line:
                    sent_and_received = re.search(r"\((\d*)/(\d*)\)", line)
                    probes_sent = int(sent_and_received.group(2))
                    probes_received = int(sent_and_received.group(1))
                    ping_dict["success"]["probes_sent"] = probes_sent
                    ping_dict["success"]["packet_loss"] = probes_sent - probes_received
                    # If there were zero valid response packets, we are done
                    if "Success rate is 0 " in line:
                        break

                    min_avg_max = re.search(r"(\d*)/(\d*)/(\d*)", line)
                    ping_dict["success"].update(
                        {
                            "rtt_min": float(min_avg_max.group(1)),
                            "rtt_avg": float(min_avg_max.group(2)),
                            "rtt_max": float(min_avg_max.group(3)),
                        }
                    )
                    results_array = []
                    for i in range(probes_received):
                        results_array.append(
                            {
                                "ip_address": py23_compat.text_type(destination),
                                "rtt": 0.0,
                            }
                        )
                    ping_dict["success"].update({"results": results_array})
        return ping_dict


    def get_bgp_neighbors_detail(self, neighbor_address=''):
        ''' All credit to nickethier
        Shamelessly lifted from
        https://github.com/nickethier/napalm/tree/ios/get_bgp_neighbors_detail
        '''
        bgp_detail = defaultdict(lambda: defaultdict(lambda: []))

        raw_bgp_sum = self._send_command('show ip bgp all sum').strip()
        bgp_sum = napalm.base.helpers.textfsm_extractor(
            self, 'ip_bgp_all_sum', raw_bgp_sum)
        for neigh in bgp_sum:
            if neighbor_address and neighbor_address != neigh['neighbor']:
                continue
            raw_bgp_neigh = self._send_command('show ip bgp {} neigh {}'.format(
                AFI_COMMAND_MAP[neigh['addr_family']], neigh['neighbor']))
            bgp_neigh = napalm.base.helpers.textfsm_extractor(
                self, 'ip_bgp_neigh', raw_bgp_neigh)[0]

            details = {
                'up': neigh['up'] != 'never',
                'local_as': napalm.base.helpers.as_number(
                    bgp_neigh['local_as'] if bgp_neigh['local_as'] else neigh['local_as']),
                'remote_as': napalm.base.helpers.as_number(neigh['remote_as']),
                'router_id': napalm.base.helpers.ip(
                    bgp_neigh['router_id']) if bgp_neigh['router_id'] else '',
                'local_address': napalm.base.helpers.ip(
                    bgp_neigh['local_address']) if bgp_neigh['local_address'] else '',
                'local_address_configured': False,
                'local_port': napalm.base.helpers.as_number(
                    bgp_neigh['local_port']) if bgp_neigh['local_port'] else 0,
                'routing_table': bgp_neigh['vrf'] if bgp_neigh['vrf'] else 'global',
                'remote_address': napalm.base.helpers.ip(bgp_neigh['neighbor']),
                'remote_port': napalm.base.helpers.as_number(
                    bgp_neigh['remote_port']) if bgp_neigh['remote_port'] else 0,
                'multihop': False,
                'multipath': False,
                'remove_private_as': False,
                'import_policy': '',
                'export_policy': '',
                'input_messages': napalm.base.helpers.as_number(
                    bgp_neigh['msg_total_in']) if bgp_neigh['msg_total_in'] else 0,
                'output_messages': napalm.base.helpers.as_number(
                    bgp_neigh['msg_total_out']) if bgp_neigh['msg_total_out'] else 0,
                'input_updates': napalm.base.helpers.as_number(
                    bgp_neigh['msg_update_in']) if bgp_neigh['msg_update_in'] else 0,
                'output_updates': napalm.base.helpers.as_number(
                    bgp_neigh['msg_update_out']) if bgp_neigh['msg_update_out'] else 0,
                'messages_queued_out': napalm.base.helpers.as_number(neigh['out_q']),
                'connection_state': bgp_neigh['bgp_state'],
                'previous_connection_state': '',
                'last_event': '',
                'suppress_4byte_as': (
                    bgp_neigh['four_byte_as'] != 'advertised and received' if
                    bgp_neigh['four_byte_as'] else False),
                'local_as_prepend': False,
                'holdtime': napalm.base.helpers.as_number(
                    bgp_neigh['holdtime']) if bgp_neigh['holdtime'] else 0,
                'configured_holdtime': 0,
                'keepalive': napalm.base.helpers.as_number(
                    bgp_neigh['keepalive']) if bgp_neigh['keepalive'] else 0,
                'configured_keepalive': 0,
                'active_prefix_count': 0,
                'received_prefix_count': 0,
                'accepted_prefix_count': 0,
                'suppressed_prefix_count': 0,
                'advertised_prefix_count': 0,
                'flap_count': 0,
            }

            bgp_neigh_afi = napalm.base.helpers.textfsm_extractor(
                self, 'ip_bgp_neigh_afi', raw_bgp_neigh)
            if len(bgp_neigh_afi) > 1:
                bgp_neigh_afi = bgp_neigh_afi[1]
                details.update({
                    'local_address_configured': bgp_neigh_afi['local_addr_conf'] != '',
                    'multipath': bgp_neigh_afi['multipaths'] != '0',
                    'import_policy': bgp_neigh_afi['policy_in'],
                    'export_policy': bgp_neigh_afi['policy_out'],
                    'last_event': (
                        bgp_neigh_afi['last_event'] if
                        bgp_neigh_afi['last_event'] != 'never' else ''),
                    'active_prefix_count': napalm.base.helpers.as_number(
                        bgp_neigh_afi['bestpaths']),
                    'received_prefix_count': napalm.base.helpers.as_number(
                        bgp_neigh_afi['prefix_curr_in']) + napalm.base.helpers.as_number(
                            bgp_neigh_afi['rejected_prefix_in']),
                    'accepted_prefix_count': napalm.base.helpers.as_number(
                        bgp_neigh_afi['prefix_curr_in']),
                    'suppressed_prefix_count': napalm.base.helpers.as_number(
                        bgp_neigh_afi['rejected_prefix_in']),
                    'advertised_prefix_count': napalm.base.helpers.as_number(
                        bgp_neigh_afi['prefix_curr_out']),
                    'flap_count': napalm.base.helpers.as_number(bgp_neigh_afi['flap_count'])
                })
            else:
                bgp_neigh_afi = bgp_neigh_afi[0]
                details.update({
                    'import_policy': bgp_neigh_afi['policy_in'],
                    'export_policy': bgp_neigh_afi['policy_out'],
                })
            bgp_detail[details['routing_table']][
                details['remote_as']].append(details)
        return bgp_detail
