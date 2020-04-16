
import salt.client
import sys
import datetime
import os
import re


def _filter_lines(config, filters):
    out_lines = []
    compiled_filters = [re.compile(i) for i in filters]
    for l in config.split('\n'):
        filter_line = False
        for f in compiled_filters:
            if f.match(l):
                filter_line = True
        if not filter_line:
            out_lines.append(l)
    return '\n'.join(out_lines)


def snap(target, name=None):
    backup_dir = '/srv/salt/snapshots'
    if not os.path.exists(backup_dir):
        os.makedirs(backup_dir)

    output = {'snapshots': {}, 'failed':{}}

    #use same timestamp for all files
    timestamp = datetime.datetime.utcnow().replace(
        microsecond=0).isoformat().replace(':', '')

    local = salt.client.LocalClient()
    result = local.cmd(
        target,
        'net.config', [],
        tgt_type='compound',
        kwarg={'source': 'running'})
    
    for dev, val in result.items():
        if name is None:
            dst = '{}/{}_{}.conf'.format(backup_dir, dev, timestamp)
        else:
            dst = '{}/{}_{}.conf'.format(backup_dir, dev, name)

        with open(dst, 'w+') as f:
            try:
                running_conf = val['out']['running']
            except:
                output['failed'][dev] = val
                continue

            filtered = _filter_lines(running_conf, [
                '^Building configuration\.\.\.$',
                '^Current configuration\s*:\s*\d+ bytes$'
            ])
            f.write(filtered)
        output['snapshots'][dev] = dst

    return output
