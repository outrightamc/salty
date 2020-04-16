#!py
from __future__ import print_function
import os.path
from glob import glob

def run():
    out = {
        'base': {}
    }

    proxy_host_configs = glob('/srv/pillar/base/network/hosts/*/*.sls')
    for p in proxy_host_configs:
        base, sls = os.path.split(p)
        hostname = os.path.splitext(sls)[0]
        region = base.split('/')[-1]
        out['base'][hostname] = [
            'server.salt.proxies.proxy-conf',
            'network.hosts.{}.{}'.format(region, hostname),
        ]

    sproxy_host_configs = glob('/srv/pillar/base/network/sproxy-hosts/*.sls')
    for p in sproxy_host_configs:
        base, sls = os.path.split(p)
        hostname = os.path.splitext(sls)[0]
        out['base'][hostname] = [
            'server.salt.proxies.proxy-conf',
            'network.sproxy-hosts.{}'.format(hostname),
        ]

    return out

if __name__ == '__main__':
    print(run())
