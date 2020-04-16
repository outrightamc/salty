#!py
from __future__ import print_function
import os.path
from glob import glob

def run():
    controller_map = {
        'pa2-sltprx-01': [],
        'ifc-sltprx-01': [],
        'atl-sltprx-01': [],
    }
    region_map = {
        'emea': 'pa2-sltprx-01',
        'noram': 'atl-sltprx-01',
        'apac': 'ifc-sltprx-01',
    }

    proxy_host_configs = glob('/srv/pillar/base/network/hosts/*/*.sls')
    for p in proxy_host_configs:
        base, sls = os.path.split(p)
        hostname = os.path.splitext(sls)[0]
        region = base.split('/')[-1]
        controller_map[region_map.get(region)].append(hostname)

    return { 'minion_controller_map': controller_map }

if __name__ == '__main__':
    print(run())
