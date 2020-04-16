import salt.client

import re
import json

# COLORED LOGS
import os, coloredlogs, logging
os.environ["COLOREDLOGS_LOG_FORMAT"] = '%(message)s'
logger = logging.getLogger(__name__)
coloredlogs.install(level='DEBUG', logger=logger)

#--------------------------------------------------------------------------------------------
# GENERAL FUNCTIONS

def net_cli(tgt, cmd):
    '''
    run net.cli command and trim output slightly
    '''

    cmd_out = ''
    local_client = salt.client.LocalClient()
    cmd_output = local_client.cmd(tgt,'net.cli',[cmd],timeout=10)
    cmd_out = cmd_output[tgt]['out'][cmd]
    cmd_out = cmd_out.replace('\n', '', 1) 
    cmd_out = cmd_out.replace('\n', '<br>')  
    return cmd_out

def yang(data):
    '''
    collect important key in yan_message from napalm-logs
    '''

    for k, v in data['yang_message'].items():
        for k1, v1 in v.items():
            for k2, v2 in v1.items():
                if k == 'bgp':
                    for k3, v3 in v2.items():
                        key = k3
                else:
                    key = k2
    return key

def extract_descr(source, cmd_out):
    '''
    extract description on interface or BGP peer description
    '''

    data = {
        'type'          : source,
        'description'   : '',
        'circuits'      : []
    }

    if re.match('^.*Description:\s(\S+)<br>.*$',cmd_out):                                   # regex to grab the description
        data['description'] = re.match('^.*Description:\s(\S+)<br>.*$',cmd_out).group(1)    # update description

        circuit_data = get_circuit(data['description'])                                     # lookup for circuit in device42
        
        if circuit_data:
            data['circuits'].append(circuit_data)

    return data

def get_circuit(descr):
    '''
    look for circuit ID in description and return data if existing
    '''

    circuit_data = None

    if re.match('^.*:CID_(\S+):.*$',descr):                                                 # regex to grab circuit ID(s)
        circuit_id = re.match('^.*:CID_(\S+):.*$', descr).group(1)                          # get circuit ID (must be converted to multi match)

        with open('/scripts/circuits.json', 'r') as circuits_json:                          # read circuits JSON file
            circuits = json.load(circuits_json)	
        circuits_json.close()

        for circuit in circuits:
            if circuit['circuit_id'] == circuit_id:                                         # if circuit match return data
                circuit_data = circuit

    return circuit_data

#--------------------------------------------------------------------------------------------
# FUNCTIONS CALLED FROM EVENTS.SLS

def compare_rollbacks(tgt):
    compare_rollbacks_output = net_cli(tgt, 'show system rollback compare 1 0')     # get compare
    data = { 'type' : 'commit', 'description' : compare_rollbacks_output }          # set description field to compare output
    return data                                                                     # return data to events.sls

def get_bgp_data(tgt, data):
    neighbor = yang(data)                                                           # BGP neighbor IP
    net_cli_output = net_cli(tgt, 'show bgp neighbor '+neighbor)
    data = extract_descr('bgp', net_cli_output)
    return data                                                                     # return data to events.sls

def get_itf_data(tgt, data):
    itf_name = yang(data)                                                           # interface name
    if not itf_name.startswith('ae'):
        net_cli_output = net_cli(tgt, 'show interfaces '+itf_name+' statistics')    # display interface statistics in order to obtain the description
        data = extract_descr('interface', net_cli_output)                           # lookup for circuit ID
        return data                                                                 # return data to events.sls
    else:
        return 'skip'                                                               # skip interface if AE