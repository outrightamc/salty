import logging
log = logging.getLogger(__name__)
import re
from tabulate import tabulate


def management_int():
    try:
        proxy_host = __pillar__['proxy']['host']
    except KeyError:
        proxy_host = False

    info = {'ip': '', 'interface': ''}

    if proxy_host != False:
        if __salt__['dnsutil.check_ip'](proxy_host):
            log.debug('found ip address for host to use directly')
            info['ip'] = proxy_host
        else:
            log.debug('found dns address for host, performing lookup')
            info['ip'] = __salt__['dnsutil.A'](proxy_host)[0]
    else:
        log.debug('found dns address for host, performing lookup')
        info['ip'] = __salt__['dnsutil.A'](proxy_host)[0]

    ipaddrs = __salt__['net.ipaddrs']()['out']
    for intf, ipinfo in ipaddrs.items():
        ipv4 = ipinfo.get('ipv4', False)
        log.debug('searching for interface with matching ip address')
        if ipv4:
            for ip in list(ipv4.keys()):
                log.debug('ip: {}, interface: {} match?'.format(ip, intf))
                if ip == info['ip']:
                    log.debug('found matching interface')
                    info['interface'] = intf
                    break
    return info


def bgp_neighbors(statefilter):
    '''
    display BGP neighbors
    > arguments:
        up: display active peers
        down: display inactive peers (Active, Connect or Idle states)
    started 08/05/2018 Sebastien - last update 17/05/2018
    '''
    if statefilter != 'up' and statefilter != 'down':
        return False, "ERROR: argument should be 'up' or 'down'"

    output_table = []
    routinginstances = __salt__['bgp.neighbors']()['out']

    for ri in routinginstances:
        for asn_list in list(routinginstances[ri].items()):
            for peer in asn_list[1]:

                entry = [
                    peer['routing_table'], asn_list[0], peer['remote_address'],
                    peer['connection_state'], peer['import_policy'] + ' / ' + peer['export_policy']
                ]

                if statefilter == 'up':
                    if peer['connection_state'] == 'Established':
                        output_table.append(entry)
                elif statefilter == 'down':
                    pattern = re.compile("^(Active|Connect|Idle.*)$")
                    if pattern.match(peer['connection_state']):
                        output_table.append(entry)

    if not output_table:
        return False
    else:
        return tabulate(
            output_table,
            headers=["Instance", "ASN", "Peer IP", "State", "Import/Export"],
            tablefmt="orgtbl")


def backbone(adv_or_recv):
    '''
    display MPLS backbone routes advertised or received
    > arguments:
        advertise: display advertised routes
        receive: display received routes
    started 01/06/2018 Sebastien - last update 01/06/2018
    '''
    if adv_or_recv != 'advertise' and adv_or_recv != 'receive':
        return False, "ERROR: argument should be 'advertise' or 'receive'"

    output_table = []
    routinginstances = __salt__['bgp.neighbors']()['out']

    if adv_or_recv == 'advertise':
        advertisement = 'advertised-routes'
    elif adv_or_recv == 'receive':
        advertisement = 'received-routes'

    for ri in routinginstances:
        for asn_list in list(routinginstances[ri].items()):
            for peer in asn_list[1]:
                if peer['connection_state'] == 'Established' and peer['routing_table'] == 'INT_VPN_CUST_ARKADIN' and peer['remote_address'].startswith(
                        '172.16.240.'):
                    cmd = 'show ip bgp vpnv4 vrf ' + peer['routing_table'] + ' neighbors ' + peer['remote_address'] + ' ' + advertisement
                    routes_dic = __salt__['net.cli'](cmd)['out']
                    prefixes_counter = 0  # reset prefixes list
                    routes = routes_dic[cmd]
                    routes_output = routes.splitlines()

                    for line in routes_output:
                        if re.match('^\*', line) or re.match('^ \*', line):
                            prefixes_counter = prefixes_counter + 1
                            pfx = line.split()
                            entry = [pfx[1]]
                            output_table.append(entry)

                    header = advertisement + ' ' + str(
                        prefixes_counter) + ' prefix(es) ' + peer['remote_address'] + ' ASN ' + str(
                            asn_list[0])

    if not output_table:
        return False
    else:
        return tabulate(output_table, headers=[header], tablefmt="orgtbl")

def interfaces(ftype):
    '''
    display interfaces
    started 20/03/2020 Sebastien - last update 23/03/2020
    '''

    if ftype != 'backbone' and ftype != 'internet' and ftype != 'voice' and ftype != 'all':
        return False,   "ERROR argument should be 'backbone', 'internet' , 'voice' or 'all' \
                        salt 'target' netutil.interfaces [backbone|internet|voice|all]"

    output_table = []
    interfaces = __salt__['net.interfaces']()['out']

    for interface, info in interfaces.items():

        pattern = re.compile("^E:(B|I|V):(.*):(.*):(.*)$")

        if pattern.match(info['description']):

            circuit_type = pattern.match(info['description']).group(1)

            if circuit_type == 'B':
                circuit_type = 'backbone'
            elif circuit_type == 'I':
                circuit_type = 'internet'
            elif circuit_type == 'V':
                circuit_type = 'voice'
                
            provider = pattern.match(info['description']).group(2)
            circuit_id = pattern.match(info['description']).group(3)
            description = pattern.match(info['description']).group(4)

            show = __salt__['net.cli']('show interfaces '+interface)['out']

            cfg_bandwidth, t_input, t_output = 'Auto', '', ''
            
            if re.match('^.*Speed Configuration:\s(\d+\w+).*$', show['show interfaces '+interface]):
                cfg_bandwidth = re.search('^.*Speed Configuration:\s(\d+\w+).*$', show['show interfaces '+interface]).group(1)
            
            if re.match('^.*Input rate\s+:\s(\S+)\sbps.*$', show['show interfaces '+interface]):
                t_input = re.search('^.*Input rate\s+:\s(\S+)\sbps.*$', show['show interfaces '+interface]).group(1)

            if re.match('^.*Output rate\s+:\s(\S+)\sbps.*$', show['show interfaces '+interface]):
                t_output = re.search('^.*Output rate\s+:\s(\S+)\sbps.*$', show['show interfaces '+interface]).group(1)

            entry = {
                'interface'     :   interface,
                'type'          :   circuit_type,
                'provider'      :   provider,
                'circuit'       :   circuit_id,
                'description'   :   description,
                'speed'         :   info['speed'],
                'up'            :   info['is_up'],
                'bandwidth'     :   cfg_bandwidth,
                'input'         :   t_input,
                'output'        :   t_output
            }

            if ftype == 'backbone':
                if circuit_type == 'backbone':
                    output_table.append(entry)
            elif ftype == 'internet':
                if circuit_type == 'internet':
                    output_table.append(entry)
            if ftype == 'voice':
                if circuit_type == 'voice':
                    output_table.append(entry)
            elif ftype == 'all':
                output_table.append(entry)

    if not output_table:
        return False
    else:
        return output_table