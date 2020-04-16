
import socket

import salt.client


def mtu_audit(size=1600):
    local = salt.client.LocalClient()
    result = local.cmd(
        '*ixrt* or *-bl-*',
        'backbone.mtu_test', [],
        kwarg={'size': size},
        tgt_type='compound')

    output = {}
    for rtr, val in result.items():
        output[rtr] = {'failed': []}

        for i in val['out']:
            if i['pass'] != True:
                try:
                    hostname, alias, ipaddr = socket.gethostbyaddr(
                        i['neighbor']['neighbor_id'])
                except socket.herror:
                    hostname = i['neighbor']['neighbor_id']

                output[rtr]['failed'].append(hostname)

    return {'out': output}
