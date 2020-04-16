import salt.client

import datetime
import os, re, base64

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

def uploader(self, method, data, url):
    payload = data
    headers = {
        'Content-type': 'application/x-www-form-urlencoded',
        'Authorization': 'Basic ' + base64.b64encode(self.d42_user + ':' + self.d42_pwd)
    }

    try:
        if method == 'POST':
            response = requests.post(url, data=payload, headers=headers, verify=False)
        elif method == 'PUT':
            response = requests.put(url, data=payload, headers=headers, verify=False)
        elif method == 'DELETE':
            response = requests.delete(url, data=payload, headers=headers, verify=False)
    except Exception as e:
        logger.critical('Unable to connect to Device42 API'+str(e))

    logger.warning(response.text)

def delete_circuit(self, data):
    url = self.d42_url + '/api/1.0/circuits/'+str(data)+'/'
    logger.info('Delete circuit ID on %s (%s)' % (data, url))
    uploader(self, 'DELETE', str(data), url)

def post_port(self, data):
    url = self.d42_url + '/api/1.0/switchports/'
    logger.info('Update/create switchports data to %s %s' % (url, data))
    uploader(self, 'POST', data, url)

def post_circuit(self, data):
    url = self.d42_url + '/api/1.0/circuits/'
    logger.info('Update/create circuit data to %s %s' % (url, data))
    uploader(self, 'POST', data, url)

def put_customfield(self, data):
    url = self.d42_url + '/api/1.0/custom_fields/circuit/'
    logger.info('Update/create circuit custom field data to %s %s' % (url, data))
    uploader(self, 'PUT', data, url)

def upload_inventory(circuits_path):
    os.system('cat \''+circuits_path+'\' | ssh opsnetwork@nio.arkadin.lan "cat > /home/opsnetwork/atlnetutil01/inventory/JSON/circuits.json"')
    logger.info('\nJSON file has been exported on atlnetutil01')


def json_inventory(circuits_list):
    
    # JSON file paths
    circuits_path = '/var/circuits/circuits.json'

    # create buffer
    circuits_json = open(circuits_path,'w')
    json.dump(circuits_list, circuits_json, indent=4)
    circuits_json.close()

    return circuits_path


def salt_interfaces(target, d42_vendors, d42_customers):
    
    itf_list = []
    
    logger.info('Parsing interfaces descriptions...')
    local = salt.client.LocalClient()   
    cmd_result = local.cmd(
            target,
            'net.interfaces',
            tgt_type='compound',
            timeout=10)

    for minion, output in cmd_result.items():

        if bool(output['result']):
            for itf in output['out']:
                d = output['out'][itf]

                dscr = re.match('^NOC:(.*):(.*):(.*):(.*):(AA|A):(PROD|PROV|DEL)$', d['description'])

                if dscr:                
                    logger.warning('''%s %s %s parsed...''' % (minion, itf, d['description']))

                    # NOC:[CIRCUIT_ID]:[TYPE]:[VENDOR_ID]:[CUSTOMER_ID]:[REDUNDANCY]:[STATUS]

                    # [CIRCUIT_ID] - UNIQUE IDENTIFIER
                    # [TYPE] - BACKBONE / SIP
                    # [VENDOR_ID] - https://device42.arkadin.lan/admin/rackraj/organisation/
                    # [CUSTOMER_ID] - https://device42.arkadin.lan/admin/rackraj/customer/
                    # [REDUNDANCY] - A = single / AA = redundant
                    # [STATUS] - PROD = production / PROV = provisioning / DEL = decommissioned

                    # examples:
                    # UNO PA2 > NOC:W131002939:BACKBONE:37:4:AA:PROD
                    # VLINK HK-SG > NOC:GIN-EU-SID2004572:BACKBONE:38:4:AA:PROV

                    C_ID = dscr.group(1)                    
                    C_type = dscr.group(2)
                    C_vendor = dscr.group(3)
                    C_customer = dscr.group(4)
                    C_redundancy = dscr.group(5)
                    C_status = dscr.group(6)

                    if C_status == 'PROD':
                        C_status = 'Production'
                    elif C_status == 'PROV':
                        C_status = 'Provisioning'

                    if C_redundancy == 'A':
                        C_redundancy = 'single'
                    elif C_redundancy == 'AA':
                        C_redundancy = 'redundant'

                    if d['is_up']:
                        protocol = 'UP'
                    else:
                        protocol = 'DOWN'

                    vendor_found = None
                    for d42_vendor in d42_vendors:

                        if int(d42_vendor['vendor_id']) == int(C_vendor):
                            C_vendor_name = d42_vendor['name']
                            vendor_found = True

                    if not vendor_found:
                        C_vendor_name = None
                        logger.critical('vendor ID %s not found' % C_vendor)

                    customer_found = None
                    for d42_customer in d42_customers:

                        if int(d42_customer['id']) == int(C_customer):
                            C_customer_name = d42_customer['name']
                            customer_found = True

                    if not customer_found:
                        C_customer_name = None
                        logger.critical('customer ID %s not found' % C_customer)

                    circuit = {
                        'minion' : minion,
                        'interface' : itf,
                        'is_enabled' : d['is_enabled'],
                        'is_up' : protocol,
                        'logical_speed' : d['speed'],
                        'hwaddress' : d['mac_address'],

                        'circuit_id' : C_ID,
                        'type' : C_type,
                        'vendor_id' : C_vendor,
                        'vendor_name' : C_vendor_name,
                        'customer_id' : C_customer,
                        'customer_name' : C_customer_name,
                        'redundancy' : C_redundancy,
                        'status' : C_status
                    }
                    itf_list.append(circuit)
        
    logger.info('')
    return itf_list

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
        self.headers = {
            'Content-type': 'application/x-www-form-urlencoded',
            'Authorization': 'Basic ' + base64.b64encode(self.d42_user + ':' + self.d42_pwd)
        }

    def get_circuits(self):
        d42_path = self.d42_url+'/api/1.0/circuits/'
        try:
            obj = requests.get(d42_path, headers=self.headers, verify=False)
            data = json.loads(obj.text)
            d42_circuits = data['circuits']
            
        except Exception as e:
            logger.critical('Unable to connect to Device42 API '+str(e))

        return d42_circuits

    def get_vendors(self):
        d42_path = self.d42_url+'/api/1.0/vendors/'
        try:
            obj = requests.get(d42_path, headers=self.headers, verify=False)
            data = json.loads(obj.text)
            d42_vendors = data['vendors']
            
        except Exception as e:
            logger.critical('Unable to connect to Device42 API '+str(e))

        return d42_vendors

    def get_customers(self):
        d42_path = self.d42_url+'/api/1.0/customers/'
        try:
            obj = requests.get(d42_path, headers=self.headers, verify=False)
            data = json.loads(obj.text)
            d42_customers = data['Customers']
            
        except Exception as e:
            logger.critical('Unable to connect to Device42 API '+str(e))

        return d42_customers

    def update_circuits(self, salt_circuits, d42_circuits):

        # CREATE/UPDATE SALT CIRCUITS IN DEVICE42
        for salt_circuit in salt_circuits:

            # PORT
            port_data = {
                'hwaddress' : salt_circuit['hwaddress'],
                'is_connected' : salt_circuit['is_up'],
                'port' : salt_circuit['interface'], 
                'switch' : salt_circuit['minion']
            }
            post_port(self, port_data)

            # CIRCUIT
            circuit_data = {
                'circuit_id' : salt_circuit['circuit_id'],
                'status' : salt_circuit['status'],
                'bandwidth' : int(salt_circuit['logical_speed']) * 1024, # convert to mbps
                'type' : salt_circuit['type'],
                'vendor_id' : salt_circuit['vendor_id'],
                'customer_id' : salt_circuit['customer_id'],
                'end_point_switch' : salt_circuit['minion'],
                'end_point_switchport' : salt_circuit['interface'],
                'end_point_type' : 'switchport'
            }
            post_circuit(self, circuit_data)

            # CIRCUIT CUSTOM FIELDS
            #custom_fields_list = []
            tribe = {'circuit_id':salt_circuit['circuit_id'], 'key':'tribe','value':'network'}
            #custom_fields_list.append(tribe)
            put_customfield(self, tribe)

        logger.info('')

        # REMOVE DEVICE42 CIRCUITS NOT DETECTED BY SALT
        for d42_circuit in d42_circuits:

            d42_circuit_found = None

            for salt_circuit in salt_circuits:
                if d42_circuit['circuit_id'] == salt_circuit['circuit_id']:
                    d42_circuit_found = True

            if not d42_circuit_found:
                for custom_field in d42_circuit['custom_fields']:
                    if custom_field['key'] == 'tribe' and custom_field['value'] == 'network':
                        logger.critical('%s %s %s (ID %s) not found... Updating Device42' % (d42_circuit['end_point_switch'], d42_circuit['end_point_switchport'], d42_circuit['circuit_id'], d42_circuit['ID']))
                        delete_circuit(self, d42_circuit['ID'])

#---------------------------------------------------------------------------------------------
# RUN MAIN FUNCTION

def run(target):

    d42 = D42() # LOAD DEVICE42 CLASS

    logger.info('Collecting Device42 vendors...')
    d42_vendors = d42.get_vendors()
    logger.info('Collecting Device42 customers...')
    d42_customers = d42.get_customers()
    logger.info('Collecting Device42 circuits...')
    d42_circuits = d42.get_circuits()
    logger.info('')

    salt_circuits = salt_interfaces(target, d42_vendors, d42_customers) # PARSE SALT INTERFACES

    if len(salt_circuits) > 0:

        d42.update_circuits(salt_circuits, d42_circuits) # UPDATE DEVICE42

        circuits_path = json_inventory(salt_circuits) # JSON INVENTORY

        upload_inventory(circuits_path) # UPDATE INVENTORY ON ATLNETUTILS01

    else:
        logger.critical('no circuit detected')

    return '-'
