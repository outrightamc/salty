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

    cmds = ['net.ipaddrs', 'net.arp', 'net.mac']
    
    for cmd in cmds:

        # https://docs.saltstack.com/en/latest/topics/targeting/compound.html
        
        cmd_result = local_client.cmd(
            target,
            cmd,
            tgt_type='compound',
            timeout=10)

        if cmd == 'net.ipaddrs':
            key = 'ipaddr'
        elif cmd == 'net.arp':
            key = 'arp'
        elif cmd == 'net.mac':
            key = 'mac'            

        for minion, output in cmd_result.items():
            if bool(output['result']):
                result = True
                if minion not in d:
                    res = {'ipaddr':list,'arp':list,'mac':list}
                    res[key] = output['out']
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
        self.mac = data['mac']

        ipaddrs_list = []
        arp_list = []
        d42_device_rancid = None
        d42_device_region = None
        d42_device_building = None

        d42_device_rack = None
        d42_device_rack_id = None
        d42_device_rack_url = None
        d42_device_room = None
        d42_device_hw_model = None

        # https://device42.arkadin.lan/admin/rackraj/rack/view/57/

        #------------------------------------------------------------------
        # IPADDRS
        for ip in data['ipaddr'].items():
            ip_data = ip[1]

            if ip[0].startswith('TenGigabitEthernet'):
                itf_name = ip[0].replace('TenGigabitEthernet', 'Te')
            elif ip[0].startswith('GigabitEthernet'):
                itf_name = ip[0].replace('GigabitEthernet', 'Gi')
            elif ip[0].startswith('Loopback'):
                itf_name = ip[0].replace('Loopback', 'Lo')
            else:
                itf_name = ip[0]

            for ip_type in ip_data.items():

                ip_version = ip_type[0]
                ip_addr_and_prefix = ip_type[1]

                for ip_info in ip_addr_and_prefix.items():

                    ip_addr = ip_info[0]
                    ip_prefix = ip_info[1]['prefix_length']

                    d42_info = self.check_d42_ip(ip_addr, d42_ipaddresses, d42_subnets, network_assets)

                    ipaddr_reformated = {
                        'salt': True,
                        'interface' : itf_name,
                        'version' : ip_version,
                        'ip' : ip_addr,
                        'prefix' : ip_prefix
                    }

                    ipaddr_reformated.update(d42_info)
                    ipaddrs_list.append(ipaddr_reformated)

        #------------------------------------------------------------------  
        # ARP
        for arp in data['arp']:
            d42_info = self.check_d42_ip(arp['ip'], d42_ipaddresses, d42_subnets, network_assets)
            mac_itf = self.check_mac(arp['mac'])
            
            if d42_info['d42_subnet'] and re.match('^.*\/(\d+)$', d42_info['d42_subnet']):
                d42_prefix = re.match('^.*\/(\d+)$', d42_info['d42_subnet']).group(1)
            else:
                d42_prefix = '0'

            arp_reformated = {
                'vlan':arp['interface'],            
                'ip':arp['ip'],
                'mac':arp['mac'],
                'mac_itf':mac_itf,                                                                     
                }

            arp_reformated.update(d42_info)
            arp_list.append(arp_reformated)

        # CUSTOM FIELDS

        for filtered_d42_device in network_assets:

            if filtered_d42_device['name'] == minion_name:

                # BUILDING
                if filtered_d42_device.get('building'):
                    d42_device_building = filtered_d42_device['building']

                # RACK & RACK ID
                if filtered_d42_device.get('rack'):
                    d42_device_rack = filtered_d42_device['rack']

                if filtered_d42_device.get('rack_id'):
                    d42_device_rack_id = filtered_d42_device['rack_id']
                    d42_device_rack_url = '''https://device42.arkadin.lan/admin/rackraj/rack/view/%s/''' % d42_device_rack_id

                # ROOM
                if filtered_d42_device.get('room'):
                    d42_device_room = filtered_d42_device['room']

                # HARDWARE MODEL
                if filtered_d42_device.get('hw_model'):
                    d42_device_hw_model = filtered_d42_device['hw_model']

                # CUSTOM_FIELDS
                for custom_field in filtered_d42_device['custom_fields']:

                    if custom_field['key'] == 'rancid' and custom_field['value']:
                        d42_device_rancid = custom_field['value']
                    
                    elif custom_field['key'] == 'region' and custom_field['value']:
                        d42_device_region = custom_field['value']  

        # CREATE FINAL MINION OBJECT DATA
        self.ipaddr = ipaddrs_list
        self.arp = arp_list

        #self.building = d42_device_building
        #self.rancid = d42_device_rancid
        #self.region = d42_device_region
        #self.rack = d42_device_rack     
        #self.room = d42_device_room
        #self.hwmodel = d42_device_hw_model

        self.minion_data = {
                'ipaddrs' : self.ipaddr,
                'arp' : self.arp
                #'building' : self.building,
                #'rancid' : self.rancid,
                #'region' : self.region,
                #'rack' : self.rack,
                #'rackurl' : d42_device_rack_url,
                #'room' : self.room,
                #'hwmodel' : self.hwmodel
        }

    #------------------------------------------------------------------
    def check_d42_ip(self, ip, d42_ipaddresses, d42_subnets, network_assets):
        """ check if IP addresses exist in Device42
        """

        ip_found_in_d42 = None
        d42_device_tribe = None

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

                if not d42_subnet_name or d42_subnet_name == 'undefined' or \
                not d42_subnet_prefix or \
                not d42_device_tribe or \
                not d42_ip['subnet']:
                    d42_error = True
                else:
                    d42_error = None

                d42_vrf = None
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
                    'd42_tribe' : d42_device_tribe,
                    'd42_error' : d42_error
                }

        if not ip_found_in_d42:         

            d42_info = {
                'd42_ip_url' : None,
                'd42_subnet' : None,
                'd42_subnet_prefix' : None,
                'd42_subnet_url' : None,
                'd42_vrf' : None,
                'd42_subnet_name' : None,
                'd42_device' : None,
                'd42_device_url' : None,
                'd42_label' : None,
                'd42_tribe' : None,
                'd42_error' : True                
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

def check_d42_ip_out(ip, d42_ipaddresses, d42_subnets, network_assets):
    """ check if IP addresses exist in Device42
    """

    ip_found_in_d42 = None
    d42_device_tribe = None

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

            d42_subnet_name = check_d42_subnet_name_out(d42_ip['subnet'])
            d42_subnet_prefix = re.match('^.*\/(\d+)|.*$',d42_ip['subnet']).group(1)

            if not d42_subnet_name or d42_subnet_name == 'undefined' or \
            not d42_subnet_prefix or \
            not d42_device_tribe or \
            not d42_ip['subnet']:
                d42_error = True
            else:
                d42_error = None

            d42_vrf = None

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
                'd42_tribe' : d42_device_tribe,
                'd42_error' : d42_error
            }

    if not ip_found_in_d42:         

        d42_info = {
            'd42_ip_url' : None,
            'd42_subnet' : None,
            'd42_subnet_prefix' : None,
            'd42_subnet_url' : None,
            'd42_vrf' : None,
            'd42_subnet_name' : None,
            'd42_device' : None,
            'd42_device_url' : None,
            'd42_label' : None,
            'd42_tribe' : None,
            'd42_error' : True                
        }               
    
    return d42_info
        
#---------------------------------------------------------------------------------------------
# RUN MAIN FUNCTION

def run():
    """ collect data from Salt and Device42
        salt-run map.run
    """
    # Passed invalid arguments: a bytes-like object is required, not 'str'
    # removed target from run function
    # workaround for Python3 migration

    target = 'I@type:network'

    local_client = salt.client.LocalClient() # SALT CLIENT HANDLER

    #------------------------------------------------------------------
    # DEVICE42

    logger.info('---------------------------------------')
    logger.info('Device42:')
    logger.info('---------------------------------------')

    device42_pwd = get_device42_pwd(local_client) # GET DEVICE42 PWD IN PILLAR
    d42 = Device42(device42_pwd) # INIT CLASS
    url = '/api/1.0/ips/?limit=0'
    target_item = 'ips'

    d42_ipaddresses_counter, d42_ipaddresses = d42.get_device42_data(url, target_item) # API REQUESTS GET IPS

    logger.info('[' + str(d42_ipaddresses_counter) + ' ip addresses]')

    d42_devices_counter, d42_devices = d42.get_device42_data('/api/1.0/devices/all/?limit=0', 'Devices') # API REQUESTS GET DEVICES
    logger.info('['+ str(d42_devices_counter) + ' devices]')

    d42_subnets_counter, d42_subnets = d42.get_device42_data('/api/1.0/subnets/?limit=0', 'subnets') # API REQUESTS GET SUBNETS
    logger.info('['+ str(d42_subnets_counter) + ' subnets]')

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
    # COPY DEVICE42 DEVICE'S DATA IF NOT SALT MINION

    logger.info('\n---------------------------------------')
    logger.info('Network tribe devices unsupported by Salt:')
    logger.info('---------------------------------------')
    logger.info('copying Device42 data for following host(s)')
    logger.info('>')

    for d in network_assets:

        #d42_device_rancid = None
        #d42_device_region = None
        #d42_device_building = None

        #d42_device_rack = None
        #d42_device_rack_id = None
        #d42_device_rack_url = None
        #d42_device_room = None
        #d42_device_hw_model = None

        #d42_in_service = None

        match = None

        d42_ip_raw_list = []


        for item in collected_data:
            for minion, data in item.items():
                if minion == d['name']:
                    match = 'match'
    
        if not match:
            logger.critical(d['name'])

            for i in d['ip_addresses']:

                d42_info = check_d42_ip_out(i['ip'], d42_ipaddresses, d42_subnets, network_assets)

                data = { 
                        'salt' : None,
                        'ip': i['ip'],                     
                    }
                data.update(d42_info)  

                d42_ip_raw_list.append(data)

            # DEVICE URL
            d42_device_url = '''https://device42.arkadin.lan/admin/rackraj/device/%s/''' % d['device_id']

            # BUILDING
            if d.get('building'):
                d42_device_building = d['building']

            # RACK & RACK ID
            if d.get('rack'):
                d42_device_rack = d['rack']

            if d.get('rack_id'):
                d42_device_rack_id = d['rack_id']
                d42_device_rack_url = '''https://device42.arkadin.lan/admin/rackraj/rack/view/%s/''' % d42_device_rack_id

            # ROOM
            if d.get('room'):
                d42_device_room = d['room']

            # HARDWARE MODEL
            if d.get('hw_model'):
                d42_device_hw_model = d['hw_model']

            # ROOM
            if d.get('in_service'):
                d42_in_service = d['in_service']

            for custom_field in d['custom_fields']:

                if custom_field['key'] == 'rancid' and custom_field['value']:
                    d42_device_rancid = custom_field['value']
                
                elif custom_field['key'] == 'region' and custom_field['value']:
                    d42_device_region = custom_field['value']  

            d42_raw = { 
                d['name'] : 
                    { 
                        'd42_device_url' : d42_device_url,
                        'ipaddrs' : d42_ip_raw_list,
                        'arp' : [],
                        'rancid' : d42_device_rancid,
                        'region' : d42_device_region,
                        'building': d42_device_building,
                        'rack' : d42_device_rack,
                        'rackurl' : d42_device_rack_url,
                        'room' : d42_device_room,
                        'hwmodel' : d42_device_hw_model,
                        'in_service' : d42_in_service
                    } 
                }

            minions_dictionary.update(d42_raw)

    #------------------------------------------------------------------
    # SAVE ALL OBJECTS TO JSON FILE
    logger.info('\n---------------------------------------')
    logger.info('Dashboard atlnetutil01:')
    logger.info('---------------------------------------')

    file_path = '/'
    file_name = 'data.json'
    file_path, file_name = write_data_to_file(minions_dictionary, file_path, file_name) 
    upload_to_atlnetutil01(file_path, file_name)

    return '-'
