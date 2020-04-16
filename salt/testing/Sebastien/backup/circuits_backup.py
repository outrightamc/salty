import salt.client

import datetime
import os, base64

import requests
import json
from requests.packages.urllib3.exceptions import InsecureRequestWarning
requests.packages.urllib3.disable_warnings(InsecureRequestWarning)

# COLOREDLOGS
import logging, coloredlogs
coloredlogs.install(level='INFO')
logger = logging.getLogger(__name__)
#os.environ["COLOREDLOGS_LOG_FORMAT"] = '%(message)s'
#coloredlogs --demo

logging.getLogger("requests").setLevel(logging.WARNING)
logging.getLogger("urllib3").setLevel(logging.WARNING)

#------------------------------------------------------------------------------------------------------
# FUNCTIONS

def uploader(self, data, url):
    payload = data
    headers = {
        'Content-type': 'application/x-www-form-urlencoded',
        'Authorization': 'Basic ' + base64.b64encode(self.d42_user + ':' + self.d42_pwd)
    }

    if 'custom_fields' in url:
        r = requests.put(url, data=payload, headers=headers, verify=False)
    else:
        r = requests.post(url, data=payload, headers=headers, verify=False)


def post_circuit(self, data):
    url = self.d42_url + '/api/1.0/circuits/'
    logger.info('\r\nPosting circuit data to %s ' % url)
    uploader(self, data, url)


def upload_inventory(circuits_path, change):

    # copy html file to atlnetutil01
    os.system('cat \''+circuits_path+'\' | ssh opsnetwork@nio.arkadin.lan "cat > /home/opsnetwork/atlnetutil01/inventory/JSON/circuits.json"')
    logger.info('JSON file has been exported on atlnetutil01')

    return True


def json_inventory(dict_entries):
    
    # JSON file paths
    circuits_path = '/var/circuits/circuits.json'
    circuits_buffer_path = '/var/circuits_buffer.json'

    # create buffer
    circuits_buffer = open(circuits_buffer_path,'w')
    json.dump(dict_entries, circuits_buffer, indent=4)
    circuits_buffer.close()

    # if no circuits inventory init with current result
    if not os.path.exists(circuits_path):
        circuits = open(circuits_path,'w')
        json.dump(dict_entries, circuits, indent=4)
        circuits.close()
    else:
        # read circuits inventory
        with open(circuits_path) as read_inventory:
            inventory = json.load(read_inventory)
            read_inventory.close()
        # read buffer
        with open(circuits_buffer_path) as read_buffer:
            buffer = json.load(read_buffer)
            read_buffer.close()

        # COMPARE
        for buffer_item in buffer['circuits']:
            match = '' # init/reset
            for item in inventory['circuits']:
 
                # UPDATE
                if item['index'] == buffer_item['index']:
                    match = 'existing_circuit'
                    # compare description for same circuit (minion + portid)
                    if not item['description'] == buffer_item['description']:
                        with open(circuits_path, 'r') as json_file:
                            data = json.load(json_file)
                            for d in data['circuits']:
                                if d['index'] == buffer_item['index']:
                                    d.clear()
                                    d.update(buffer_item)
                                    
                        with open(circuits_path, 'w') as json_file:
                            json.dump(data, json_file, indent=4)
                        json_file.close()
                        logger.warning('''update %s description %s > %s''' % (buffer_item['index'], item['description'], buffer_item['description']))
                
            # ADD CIRCUIT IF NOT EXISTING
            if not match == 'existing_circuit':
                logger.warning('''add %s''' %(buffer_item['index']))

            # CLEAR CIRCUITS IF NOt IN PILLAR
            for item in inventory['circuits']:
                match = '' # init/reset
                for buffer_item in buffer['circuits']:
                    if buffer_item['index'] == item['index']:
                        match = 'existing_circuit'

            if not match == 'existing_circuit':
                with open(circuits_path, 'r') as json_file:
                    data = json.load(json_file)
                    for d in data['circuits']:
                        if d['index'] == item['index']:
                            d.clear()
                            d.update(item)
                                    
                with open(circuits_path, 'w') as json_file:
                    json.dump(data, json_file, indent=4)
                json_file.close()
                logger.warning('''remove %s''' %(item['index']))
    return circuits_path


def inventory(d42):

    d42_circuits = d42.getcircuits()
    
    logger.warning(d42_circuits)
    
    circuit = False # init circuit variable
    change = 'none'

    dict_entries = {}
    dict_entries['circuits'] = []

    local = salt.client.LocalClient()   
    master_result = local.cmd('pa2-sltmst-01', 'pillar.get', ['circuits'], timeout=10)

    # START PARSING CIRCUITS PILLAR ATTACHED TO SALT MASTER
    logger.info('start parsing pillar')

    for minion in master_result['pa2-sltmst-01']:

        circuits = local.cmd('pa2-sltmst-01', 'pillar.get', ['''circuits:%s''' % (minion)], timeout=10) # collect circuits for minion
        dcdic = local.cmd(minion, 'pillar.get', ['dc'], timeout=10) # collect minion DC
        dc = dcdic[minion]
        regiondic = local.cmd(minion, 'pillar.get', ['region'], timeout=10) # collect minion DC
        region = regiondic[minion]

        for circuit in circuits['pa2-sltmst-01']: # display circuits information

            # collect interfaces available on minion
            interfaces = local.cmd(minion, 'net.interfaces', timeout=10) 

            if not bool(interfaces[minion]['out']):
                logger.critical('''net.interfaces returned no results for %s''' % (minion))
            # compare description for each interfaces available in circuits pillar
            for itf in interfaces[minion]['out']:

                if itf == circuit['portid']:
                    #description {{ i.monitoring }}:{{ i.type }}:{{ i.redundancy }}:\
                    # {{ i.provider }}:{{ i.circuitid }}:{{ i.contact }}
                    target_description = \
                    circuit['monitoring'] + ':' + \
                    circuit['type'] + ':' + \
                    circuit['redundancy'] + ':' + \
                    circuit['provider'] + ':' + \
                    circuit['circuitid'] + ':' + \
                    circuit['contact']

                    # DESCRIPTION ALREADY UP TO DATE
                    if interfaces[minion]['out'][itf]['description'] == target_description:
                        logger.warning('''%s port %s description [%s] is already up to date''' % \
                        (minion, circuit['portid'], interfaces[minion]['out'][itf]['description']))            
                    else:
                        # DESCRIPTION UPDATE REQUIRED
                        logger.critical('''%s port %s description [%s] needs to be updated to [%s]''' % \
                        (minion, circuit['portid'], interfaces[minion]['out'][itf]['description'], target_description))
                        change = 'change_required'

                    # ADD CIRCUIT
                    dic = {
                        'index': minion+'_'+circuit['portid'],
                        'minion': minion,
                        'portid': circuit['portid'],
                        'region': region,
                        'dc': dc,
                        'speed': interfaces[minion]['out'][itf]['speed'],
                        'bandwidth': circuit['bandwidth'],
                        'monitoring': circuit['monitoring'],
                        'type': circuit['type'],   
                        'redundancy': circuit['redundancy'],
                        'provider': circuit['provider'],
                        'circuitid': circuit['circuitid'],
                        'contact': circuit['contact'],
                        'description': target_description,
                        'update': str(datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S"))
                    }
                    dict_entries['circuits'].append(dic)

                    d42.update_device42(d42_circuits, dic)

        if circuit:
            logger.info('''[circuits have been parsed for %s]''' % (minion))
        else:
            logger.critical('''[no circuits detected for %s]''' % (minion))

        if change == 'change_required':
            logger.critical('''applying configuration update for %s''' % (minion))
            apply_config = local.cmd(minion, 'state.apply', ['network.circuits'], timeout=10)

            # DEBUG
            output = apply_config[minion]['netconfig_|-circuits_|-circuits_|-managed']
            if output['comment'] == 'Configuration changed!\n' \
            and output['result'] == True:
                logger.warning('''network.circuits state has been applied to %s''' % (minion))
            else:
                logger.critical('''network.circuits state was not applied successfully to %s''' % (minion))
                logger.warning(output)

            change = 'change_applied'

    logger.info('stop parsing pillar')
    # END PARSING PILLAR

    # JSON INVENTORY
    circuits_path = json_inventory(dict_entries)

    # UPDATE INVENTORY ON ATLNETUTILS01
    upload_inventory(circuits_path, change)

    return 'circuits inventory completed'


class D42():
    def __init__(self):

        pwd_file = '/opwd'
        pwd_file = open(pwd_file,'r')
        pwd_encoded = pwd_file.readlines()
        for line in pwd_encoded:
            if line.startswith('admin'):
                pwd_encoded_device42 =  line.split('|')[1]      
        pwd_file.close()
        pwd_decoded_device42 = base64.b64decode(pwd_encoded_device42)

        self.d42_url = 'https://device42.arkadin.lan'
        self.d42_user = 'admin'
        self.d42_pwd = pwd_decoded_device42
        self.d42_api = '/api/1.0/circuits/'


    def getcircuits(self):
        d42_get = self.d42_url+self.d42_api

        headers = {
            'Content-type': 'application/x-www-form-urlencoded',
            'Authorization': 'Basic ' + base64.b64encode(self.d42_user + ':' + self.d42_pwd)
        }

        try:
            obj = requests.get(d42_get, headers=headers, verify=False)
            data = json.loads(obj.text)

            d42_circuits = data['circuits']
            
        except Exception, e:
            logger.critical(str(e))
            logger.critical('Unable to connecto to Device42 API')

        return d42_circuits

    def update_device42(self, d42_circuits, dic):

        circuitdata = {}
        matchd42 = ''

        for d42_circuit in d42_circuits:
            if dic['circuitid'] == d42_circuit['circuit_id']:
                matchd42 = 'match'

        if not matchd42 == 'match':
            circuitdata.update({'circuit_id': dic['circuitid']})
            circuitdata.update({'type': dic['type']})
            post_circuit(self, circuitdata)


#---------------------------------------------------------------------------------------------
# RUN MAIN FUNCTION

def run():
    d42 = D42()
    inventory(d42)

    return '-'
