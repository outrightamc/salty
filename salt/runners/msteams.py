import pymsteams # https://pypi.org/project/pymsteams/
import json
import os
import datetime

def get_logo(party_type, party_id):

    logo = ''

    # VENDORS
    if party_type == 'vendor' and party_id == '54':
        logo = 'http://vps176934.vps.ovh.ca/msicons/zayo-logo.png'

    # CUSTOMERS
    elif party_type == 'customer' and party_id == '4':
        logo = 'http://vps176934.vps.ovh.ca/msicons/ntt-logo.png'

    return logo

def notification(msg):
    # add line to remote atlnetutil01 log file
    message = 'error|'+str(datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S"))+'|'+msg
    os.system('echo \''+message+'\' | ssh opsnetwork@nio.arkadin.lan "cat >> /home/opsnetwork/atlnetutil01/atlnetutil01.log"')

# https://docs.microsoft.com/en-us/microsoftteams/platform/task-modules-and-cards/cards/cards-format
def send_message(definition, host, message, data):

    sectiondefinition = None
    sectiondescr = None
    sectioncircuit = None
    sectioncontact = None

    # DEFINE MS TEAMS CONNECTORCARD
    teamsmsg = pymsteams.connectorcard("https://outlook.office.com/webhook/98fb1237-76f2-4e84-8a71-395d9ca4e714@2596d791-95a9-4f15-97b6-bfb8760e0ac4/IncomingWebhook/e74c7180a6184932a80fca52cd03e31c/df57b74c-0543-48ff-8470-4d194086c845")
    
    host_elk_url = '''<a target="_blank" href="https://arkaelk.arkadin.lan/app/kibana#/discover?_g=(refreshInterval:(pause:!t,value:0),time:(from:now-7d,mode:quick,to:now))&_a=(columns:!(host,hostname,os,message),filters:!(('$state':(store:appState),meta:(alias:!n,disabled:!f,index:c50faf40-a92e-11e9-86ff-2decbf7e9534,key:hostname,negate:!f,params:(query:%s,type:phrase),type:phrase,value:%s),query:(match:(hostname:(query:%s,type:phrase))))),index:c50faf40-a92e-11e9-86ff-2decbf7e9534,interval:auto,query:(language:lucene,query:''),sort:!('@timestamp',desc))">%s</a>''' % (host, host, host, host)
    
    #teamsmsg.text('<font color=blue><b>'+definition+'</b></font> on <b>'+host_elk_url+'</b><br>'+message)

    sectiondefinition = pymsteams.cardsection()
    sectiondefinition.activityText('<font color=blue><b>'+definition+'</b></font> on <b>'+host_elk_url+'</b><br>'+message)

    # DESCRIPTION
    if data['description'] == 'no description':
        sectiondescr = pymsteams.cardsection()
        description = '<font color=red><b>description:</b> no description defined</font>'
        sectiondescr.activityText(description)
    else:
        if len(data['description']) > 0:
            sectiondescr = pymsteams.cardsection()
            description = '<b>description:</b> <i>'+data['description']+'</i>'
            sectiondescr.activityText(description)
    
    sectioncircuit = pymsteams.cardsection()

    if 'circuit' in data and len(data['circuit']) == 0:
        circuits_txt = '<font color=red><b>circuit:</b> no item(s) identified</font>'
        sectioncircuit.activityText(circuits_txt)

    # CIRCUITS
    if 'circuit' in data and len(data['circuit']) > 0:

        circuits_txt = '<b>circuit(s):</b> '
        
        for circuit in data['circuit']:

            ID                      = circuit['ID']
            circuit_id              = circuit['circuit_id']

            circuit_bandwidth       = str(circuit['bandwidth']).strip()

            if circuit_bandwidth    == '1048576':
                circuit_bandwidth   = '1Gbps'

            origin_id               = circuit['origin_id']
            origin_switch           = circuit['origin_switch']
            origin_switchport       = circuit['origin_switchport']
            
            circuit_type            = circuit['type'].lower()
            circuit_status          = circuit['status'].lower()

            end_point_id            = circuit['end_point_id']
            end_point_switch        = circuit['end_point_switch']
            end_point_switchport    = circuit['end_point_switchport']

            customer                = circuit['customer']
            customer_id             = str(circuit['customer_id'])
            vendor                  = circuit['vendor']
            vendor_id               = str(circuit['vendor_id'])

            url_circuit             = 'https://device42.arkadin.lan/admin/rackraj/circuit'
            url_netport             = 'https://device42.arkadin.lan/admin/rackraj/netport'
            url_customer            = 'https://device42.arkadin.lan/admin/rackraj/customer'
            url_vendor              = 'https://device42.arkadin.lan/admin/rackraj/organisation'

            circuits_txt += ''' <b><a target="_blank" href={url_circuit}/{ID}/>{circuit_id}</a></b><br>
                                <b>type:</b> {type}, <b>bandwidth:</b> {bandwidth}, <b>status:</b> {status}<br>
                                <b>origin:</b> <a target="_blank" href={url_origin}/{origin_id}/>{origin_switch} {origin_switchport}</a> 
                                <b>end point:</b> <a target="_blank" href={url_end_point}/{end_point_id}/>{end_point_switch} {end_point_switchport}</a><br>
                        '''.format( 
                                    url_circuit=url_circuit, ID=ID, circuit_id=circuit_id,
                                    type= circuit_type, bandwidth=circuit_bandwidth, status=circuit_status,
                                    url_origin=url_netport, origin_id=origin_id, origin_switch=origin_switch, origin_switchport=origin_switchport,
                                    url_end_point=url_netport, end_point_id=end_point_id, end_point_switch=end_point_switch, end_point_switchport=end_point_switchport
                            )

            sectioncircuit.activityText(circuits_txt)


            vendor_txt = ''
            customer_txt = ''

            if vendor or customer:
                sectioncontact = pymsteams.cardsection()

                # VENDOR (organization)
                if vendor:
                    logo_vendor = get_logo('vendor', vendor_id)
                    vendor_txt = '''<b>vendor:</b> <a target="_blank" href={url_vendor}/{vendor_id}/>{vendor}</a>
                                '''.format(url_vendor=url_vendor, vendor_id=vendor_id, vendor=vendor)
                    sectioncontact.addImage(logo_vendor)

                # CUSTOMER
                if customer:
                    logo_customer = get_logo('customer', customer_id)
                    customer_txt = '''<b>customer:</b> <a target="_blank" href={url_customer}/{customer_id}/>{customer}</a></a>
                                '''.format(url_customer=url_customer, customer_id=customer_id, customer=customer)
                    sectioncontact.addImage(logo_customer)                                           
                
                sectioncontact.activityText(vendor_txt+' '+customer_txt)

            if vendor and customer:
                sectiondescr = None

    # ADD SECTIONS

    if sectiondefinition:                       # DEFINITION
        teamsmsg.addSection(sectiondefinition)

    if sectiondescr:                            # DESCRIPTION
        teamsmsg.addSection(sectiondescr)

    if sectioncircuit:
        teamsmsg.addSection(sectioncircuit)     # CIRCUITS

    if sectioncontact:
        teamsmsg.addSection(sectioncontact)     # CONTACTS
    
    teamsmsg.summary("Saltstack")

    teamsmsg.send()

    # notification('test 26/02/2020')