
import salt.client
import sys
import yaml


def run(testlet_file):
    with open(testlet_file) as f:
        testlet_data = f.read()
        testlet = yaml.load(testlet_data)

    local = salt.client.LocalClient()
    supported_tests = {'ping': 'net.ping'}

    salt_mod = supported_tests.get(testlet['test'], False)
    if salt_mod is False:
        return {'error': "unsupported test: {}".format(testlet['test'])}

    out = {'results': {}}
    for t in testlet['targets']:
        if 'subset' in testlet['source']:
            result = local.cmd_subset(
                testlet['source']['value'],
                salt_mod, [t],
                sub=int(testlet['source']['subset']),
                tgt_type=testlet['source']['type'])
        else:
            result = local.cmd(
                testlet['source']['value'],
                salt_mod, [t],
                tgt_type=testlet['source']['type'])

        if testlet['test'] == 'ping':
            out['results'][t] = []
            for minion, res in list(result.items()):
                try:
                    loss = res['out']['success']['packet_loss']
                except KeyError:
                    return {'error': res}
                if loss == 0:
                    code = "ok"
                else:
                    code = "failed"
                out['results'][t].append({
                    minion: {
                        'code': code,
                        'loss': loss
                    }
                })

    return out
