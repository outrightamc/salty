import re
from passlib.hash import cisco_type7


def vrf_membership(interface, instance):
    ''' case insensitive search through routing-instance member interfaces '''
    for iname, iconf in list(instance.items()):
        for intf in iconf['interfaces']:
            if intf.lower() == interface.lower():
                return iname
    return None


def _expand_vlans(vraw):
    ev = []
    for v in vraw.split(','):
        if '-' in v:
            l, h = v.split('-')
            ev += list(range(int(l), int(h) + 1))
        else:
            ev.append(int(v))
    return ev


def _map_int_trunk(input, expand=False):
    output = {'out': {}}
    for d in input['out']['show interfaces trunk']:
        if expand:
            output['out'][d['port']] = _expand_vlans(d['vlans'])
        else:
            output['out'][d['port']] = d['vlans']

    return output


def vlan_trunked(trunk_map, interface, vlan):
    m = re.search('(\D{,2})\D*([\d\/]*)', interface)
    shortname = m.group(1) + m.group(2)
    if int(vlan) in trunk_map.get(shortname, []):
        return True
    return False


def show_vlan():
    output = __salt__['net.cli'](
        'show vlan',
        textfsm_parse=True,
        textfsm_template='salt://_textfsm/ios_show_vlan.textfsm')
    return output


def show_int_trunk(expand=False):
    output = __salt__['net.cli'](
        'show interfaces trunk',
        textfsm_parse=True,
        textfsm_template='salt://_textfsm/ios_show_interfaces_trunk.textfsm')
    return _map_int_trunk(output, expand)


def to_type7(plaintext, fixed_salt=True, salt=12):
    if fixed_salt:
        halg = cisco_type7.using(salt=salt)
    else:
        halg = cisco_type7()
    ciphertext = halg.hash(plaintext)
    return ciphertext


def get_syslog_servers():
    cmd = 'show run | i ^logging.*[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+'
    output = __salt__['net.cli'](cmd)
    try:
        servers = re.findall('[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+',
                             output['out'][cmd])
    except KeyError:
        return {"error": output}
    return list(servers)


def list_diff(current, desired):
    '''
    return the required changes to to update old list to new list.
    '''
    ret = {'remove': [], 'add': []}
    for i in current:
        if i not in desired:
            ret['remove'].append(i)
    for i in desired:
        if i not in current:
            ret['add'].append(i)
    return ret
