# SALT
import salt.client

# GENERAL
import datetime
import json
import os
import re
import sys

# DEVICE42
import base64
import requests
from requests.packages.urllib3.exceptions import InsecureRequestWarning
requests.packages.urllib3.disable_warnings(InsecureRequestWarning)

# COLOREDLOGS
import logging, coloredlogs
os.environ["COLOREDLOGS_LOG_FORMAT"] = '%(message)s'
coloredlogs.install(level='INFO')
logger = logging.getLogger(__name__)

#------------------------------------------------------------------------------------------------------
# FUNCTIONS

def get_device42_pwd(local_client):
    """ get Device42 password (base64) 
        from pa2-sltmst-01 pillar
    """
    cmd_result = local_client.cmd(
        'pa2-sltmst-01',
        'pillar.items',
        ['device42'],
        timeout=10)

    device42_pwd = cmd_result['pa2-sltmst-01']['device42']

    return device42_pwd

def collect_data(local_client, target):
    """ collect ARP, IP addresses and MAC 
        on Salt minions
    """
    
    l = []
    d = {}
    result = None

    cmds = ['net.arp', 'net.mac']

    for cmd in cmds:
        
        cmd_result = local_client.cmd(
            target,
            cmd,
            tgt_type='compound',
            timeout=10)

        if cmd == 'net.arp':
            key = 'net.arp'
        elif cmd == 'net.mac':
            key = 'net.mac'

        for minion, output in cmd_result.items():
            if bool(output['result']):
                result = True
                if minion not in d:
                    res = {'arp':list,'mac':list}
                    res[key] = output['out']
                    logger.warning('add key '+key+' for minion '+minion)
                    d[minion] = res
                else:
                    res = d[minion]
                    res.update({key:output['out']})

    if result:
        l.append(d)
        return l
    else:
        return None

def write_data_to_file(data, file_path, file_name):
    """ write JSON data to file
    """
    logger.info(file_name+' saved')
    
    json_file = open(file_path+file_name,'w')
    json.dump(data, json_file, indent=4)
    json_file.close()
    
    return file_path, file_name

def upload_to_atlnetutil01(file_path, file_name):
    """ upload JSON file to atlnetutil01
    """

    os.system(
        'cat \''+file_path+file_name+'\' | \
        ssh opsnetwork@nio.arkadin.lan "cat > \
        /home/opsnetwork/atlnetutil01/inventory/JSON/'+file_name+'"'
        )
    logger.warning('''%s file uploaded to atlnetutil01''' % file_name)
  
#---------------------------------------------------------------------------------------------
# CLASSES

class Minion:
    """ reformat Salt network modules output
        and create object for each minion
    """
    def __init__(self, minion_name, data, d42_ipaddresses, d42_subnets, network_assets):

        self.name = minion_name
        self.mac = data['net.mac']

        arp_list = []

        for arp in data['net.arp']:

            # check IP in Device42
            d42_info = self.check_d42_ip(arp['ip'], d42_ipaddresses, d42_subnets, network_assets)

            # check MAC
            mac_itf = self.check_mac(arp['mac'])      

            arp_reformated = {
                'vlan':arp['interface'],            
                'ip':arp['ip'],
                'mac':arp['mac'],
                'mac_itf':mac_itf,                                                                     
                }

            if d42_info:
                arp_reformated.update(d42_info)

            arp_list.append(arp_reformated)

        self.arp = arp_list

        self.minion_data = {
                'arp' : self.arp
        }

    #------------------------------------------------------------------
    def check_d42_ip(self, ip, d42_ipaddresses, d42_subnets, network_assets):
        """ check if IP addresses exist in Device42
        """

        ip_found_in_d42 = None
        d42_device_tribe = None
        d42_vrf = None
        d42_info = None

        # CHECK DEVICE42 IP ADDRESSES
        for d42_ip in d42_ipaddresses:
            if ip == d42_ip['ip']:               
                ip_found_in_d42 = 'match'

                if d42_ip['device']:
                    d42_device_url = '''https://device42.arkadin.lan/admin/rackraj/device/%s/''' % d42_ip['device_id']

                    # PARSE DEVICE42 DEVICES
                    for filtered_d42_device in network_assets:
                        
                        if d42_ip['device_id'] == filtered_d42_device['device_id']:

                            for custom_field in filtered_d42_device['custom_fields']:
                                if custom_field['key'] == 'tribe' and custom_field['value']:
                                    d42_device_tribe = custom_field['value']    
                else:
                    d42_device_url = None

                d42_subnet_name = self.check_d42_subnet_name(d42_ip['subnet'])
                d42_subnet_prefix = re.match('^.*\/(\d+)|.*$',d42_ip['subnet']).group(1)

                for d42_subnet in d42_subnets:
                    if d42_subnet['subnet_id'] == d42_ip['subnet_id']:
                        d42_vrf = d42_subnet['vrf_group_name']

                d42_info = {
                    'd42_ip_url' : '''https://device42.arkadin.lan/admin/rackraj/ip_address/%s/''' % d42_ip['id'],
                    'd42_subnet' : d42_ip['subnet'],
                    'd42_subnet_name' : d42_subnet_name,
                    'd42_subnet_prefix' : d42_subnet_prefix,
                    'd42_subnet_url' : '''https://device42.arkadin.lan/admin/rackraj/vlan/%s/''' % d42_ip['subnet_id'],
                    'd42_vrf' : d42_vrf,
                    'd42_device' : d42_ip['device'],
                    'd42_device_url' : d42_device_url,
                    'd42_label' : d42_ip['label'],
                    'd42_tribe' : d42_device_tribe
                }      
     
        return d42_info

    #------------------------------------------------------------------
    def check_d42_subnet_name(self, subnet):
        if re.match('^(.*)\-(\d+.\d+.\d+.\d+/\d+)$', subnet):
            d42_subnet_name = re.match('^(.*)\-(\d+.\d+.\d+.\d+/\d+)$', subnet).group(1)
        else:
            d42_subnet_name = None

        return d42_subnet_name

    #------------------------------------------------------------------
    def check_mac(self, mac):
        """ check if MAC in CAM
        """

        mac_itf = None
        mac_match = None
        
        for mac_address in self.mac:
            if mac in mac_address['mac']:
                mac_match = 'match'
                if mac_address['static'] == False:
                    mac_itf = mac_address['interface']
                else:
                    mac_itf = 'static'

        if not mac_match:
            mac_itf = '-'

        return mac_itf

class Device42:
    """ connect to Device42 API and collect data
        https://api.device42.com
    """

    def __init__(self, device42_pwd):
        self.d42_url = 'https://device42.arkadin.lan'
        self.d42_user = 'admin'
        self.d42_pwd = device42_pwd

    #------------------------------------------------------------------
    def get_device42_data(self, api_url, field):
        d42_get = self.d42_url+api_url

        string_to_encode = self.d42_user + ':' + self.d42_pwd
        base64encoded_pwd = base64.b64encode(string_to_encode.encode())
        headers = {
            'Content-type': 'application/x-www-form-urlencoded',
            'Authorization': 'Basic ' + str(base64encoded_pwd.decode())
        }
        try:
            logger.warning('''requesting %s to Device42 API...''' % (field))
            obj = requests.get(d42_get, headers=headers, verify=False)
            device42_data = json.loads(obj.text)

            counter = 0

            for item in device42_data[field]:
                counter += 1

            with open('/'+field+'.json', 'w') as device42_json:
                json.dump(device42_data[field], device42_json, indent=4)
            device42_json.close()

            return counter, device42_data[field]

            logger.info('')

        except Exception as e:
            logger.critical('Unable to connecto to Device42 API')
        

def check_d42_subnet_name_out(subnet):
    if re.match('^(.*)\-(\d+.\d+.\d+.\d+/\d+)$', subnet):
        d42_subnet_name = re.match('^(.*)\-(\d+.\d+.\d+.\d+/\d+)$', subnet).group(1)
    else:
        d42_subnet_name = None

    return d42_subnet_name
        
#---------------------------------------------------------------------------------------------
# RUN MAIN FUNCTION

def run(device42_collect):
    """ collect data from Salt and Device42
        salt-run map.run [device42][no]
        [device42] will pull Device42
        [no] will read local JSON in order to speed up troubleshooting
    """
    # Passed invalid arguments: a bytes-like object is required, not 'str'
    # removed target from run function
    # workaround for Python3 migration

    #target = 'I@type:network'
    target = 'aubcore02'

    local_client = salt.client.LocalClient() # SALT CLIENT HANDLER

    #------------------------------------------------------------------
    # DEVICE42

    logger.info('---------------------------------------')
    logger.info('Device42:')
    logger.info('---------------------------------------')

    device42_pwd = get_device42_pwd(local_client) # GET DEVICE42 PWD IN PILLAR
    d42 = Device42(device42_pwd) # INIT CLASS

    if device42_collect == 'device42':
        d42_ipaddresses_counter, d42_ipaddresses = d42.get_device42_data('/api/1.0/ips/?limit=0', 'ips') # API REQUESTS GET IPS
        logger.info('[' + str(d42_ipaddresses_counter) + ' ip addresses]')
        d42_devices_counter, d42_devices = d42.get_device42_data('/api/1.0/devices/all/?limit=0', 'Devices') # API REQUESTS GET DEVICES
        logger.info('['+ str(d42_devices_counter) + ' devices]')
        d42_subnets_counter, d42_subnets = d42.get_device42_data('/api/1.0/subnets/?limit=0', 'subnets') # API REQUESTS GET SUBNETS
        logger.info('['+ str(d42_subnets_counter) + ' subnets]')
    else:
        logger.warning('reading local JSON files...')
        with open('/ips.json') as device42_json:
            d42_ipaddresses = json.load(device42_json)
            d42_ipaddresses_counter = 0
        device42_json.close()

        with open('/Devices.json') as device42_json:
            d42_devices = json.load(device42_json)
            d42_devices_counter = 0
        device42_json.close()

        with open('/subnets.json') as device42_json:
            d42_subnets = json.load(device42_json)
            d42_subnets_counter = 0
        device42_json.close()

    #------------------------------------------------------------------
    # FILTERING DEVICE42 DEVICES
    network_assets = []

    for d42_device in d42_devices:

        d42_device_tribe = None

        for custom_field in d42_device['custom_fields']:
            
            if custom_field['key'] == 'tribe' and custom_field['value']:
                d42_device_tribe = custom_field['value']
        
        if d42_device_tribe == 'Network':
            network_assets.append(d42_device)

    #------------------------------------------------------------------
    # COLLECT DATA ON SALTSTACK MINIONS
    logger.info('\n---------------------------------------')
    logger.info('Saltstack:')
    logger.info('---------------------------------------')

    logger.warning('collect data on minions...')   
    collected_data = collect_data(local_client, target)
    minions_dictionary = {} # MINIONS DICTIONARY

    #------------------------------------------------------------------
    # COMPARE WITH DATA COLLECTED ON SALT MINIONS
    target_count = 0

    for item in collected_data:
        for minion, data in item.items():
            target_count = target_count + 1
    
    logger.info(str(target_count)+' minion(s) targeted')

    for item in collected_data:

        for minion, data in item.items():

            logger.warning(minion)

            m = Minion(minion, data, d42_ipaddresses, d42_subnets, network_assets) # CREATE MINION OBJECT

            minions_dictionary.update(
                    {   
                        m.name : m.minion_data
                    }
                ) # UPDATE OBJECT IN DICTIONARY

    #------------------------------------------------------------------
    # SAVE ALL OBJECTS TO JSON FILE
    logger.info('\n---------------------------------------')
    logger.info('Dashboard atlnetutil01:')
    logger.info('---------------------------------------')

    file_path = '/'
    file_name = 'salt.json'
    file_path, file_name = write_data_to_file(minions_dictionary, file_path, file_name) 
    upload_to_atlnetutil01(file_path, file_name)

    return '-'
