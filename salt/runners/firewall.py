import logging
import os
log = logging.getLogger(__name__)
from tabulate import tabulate
import json
import datetime
import smtplib
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
from email.mime.application import MIMEApplication
from email.mime.image import MIMEImage
import salt.client
import salt.runner
import salt.config

def hitcount(data_str):
    '''
    collect policies hit count via RPC
    started 05/07/2018 Sebastien - last update 24/12/2019
    24/12/2019 corrected policies hitcount counter when reset
    '''
    data = eval(data_str)
    minion = data['id']
    # minion = 'ifc-fw-01'
    output_table = []
    error_summary = None

    local = salt.client.LocalClient()
    policies_output = local.cmd(minion, 'napalm.junos_rpc', ['get-security-policies-hit-count'])

    if minion == 'mtp-fw-02':
        policies = policies_output[minion]['out']['policy-hit-count']['policy-hit-count-entry']
    else:
        policies = policies_output[minion]['out']['multi-routing-engine-results']['multi-routing-engine-item']['policy-hit-count']['policy-hit-count-entry']

    # json file paths
    jsonfile_last_path = '/var/audits/firewalls/'+minion+'_last.json'
    jsonfile_new_path = '/var/audits/firewalls/'+minion+'_new.json'

    # create new json file
    jsonfile_new = open(jsonfile_new_path,'w')
    dict_entry = {}
    dict_entry['acls'] = []
    date = datetime.datetime.now()

    for policy in policies: # parse policies hit-count table
        hc_index = policy['policy-hit-count-index']
        hc_from = policy['policy-hit-count-from-zone']
        hc_to = policy['policy-hit-count-to-zone']
        hc_name = policy['policy-hit-count-policy-name']
        hc_count = policy['policy-hit-count-count']
        hc_timestamp = str(date)

        tabulate_entry = [minion, hc_index, hc_from, hc_to, hc_name, hc_count, hc_timestamp]

        if (not hc_name == 'ICMP'):
            output_table.append(tabulate_entry) # add entry to output_table

            dict_entry['acls'].append({
                'minion': minion,  
                'index': hc_index,
                'from': hc_from,
                'to': hc_to,
                'name': hc_name,   
                'count': hc_count,
                'timestamp': hc_timestamp
            })

    json.dump(dict_entry, jsonfile_new, indent=4)
    jsonfile_new.close()

    table = tabulate(
        output_table,
        headers=['minion','index','from','to','name','count','timestamp'],
        tablefmt="orgtbl")

    # if no last file, init with current result
    if not os.path.exists(jsonfile_last_path):
        jsonfile_last = open(jsonfile_last_path, 'w')
        json.dump(dict_entry, jsonfile_last, indent=4)
        jsonfile_last.close()

    # get HTML output via wrapper
    htmlmsg, subject, error_summary = htmlwrapper(minion, jsonfile_last_path, jsonfile_new_path)

    upload_atlnetutil01(htmlmsg, minion)

    #if error_summary:
    #   notification(htmlmsg, subject, minion)

    return table

def htmlwrapper(minion, jsonfile_last_path, jsonfile_new_path):
    tablecontent = ''
    mop = ''
    reset = None
    opts = salt.config.master_config('/etc/salt/master') # define salt runner opts
    runner = salt.runner.RunnerClient(opts)#opts

    with open(jsonfile_last_path) as read_last:
        data_last = json.load(read_last)
        read_last.close()
        
    with open(jsonfile_new_path) as read_new:
        data_new = json.load(read_new)
        read_new.close()
        prev_from = None
        prev_to = None
        error_summary = None

        pillar = runner.cmd('pillar.show_pillar', [minion])
        acl_list = pillar['policy_exceptions']['acl']
        
        for pnew in data_new['acls']:

            # resets
            color_cell = ''
            comment = ''
            comment_elapsed = None
            color_font = 'black'
            update = 'no'
            error_acl = None
            exceptions_match = None

            for plast in data_last['acls']:

                # if match same ACL
                if pnew['from'] == plast['from'] and pnew['to'] == plast['to'] and pnew['name'] == plast['name']:

                    # get hit count increase
                    counter_new_hit = int(pnew['count']) - int(plast['count'])

                    # ISO 8601 datetime YYYY-MM-DD HH:MM:SS
                    format = '%Y-%m-%d %H:%M:%S.%f'
                    new_datetime = datetime.datetime.strptime(pnew['timestamp'], format)

                    # testing atl-fw-01
                    # if pnew['from'] == 'C1_LYNC_VDED_EDGE' and pnew['to'] == 'INET_BDR_INTERCO' and pnew['name'] == 'HTTP':
                    #   print('forcing las timestamp for atl-fw-01 policy C1_LYNC_VDED_EDGE / INET_BDR_INTERCO / HTTP')
                    #    plast['timestamp'] = '2019-02-28 10:21:44.380937' # > 90 days
                    #    counter_new_hit = 0

                    last_datetime = datetime.datetime.strptime(plast['timestamp'], format)

                    elapsed_time = new_datetime - last_datetime

                    if counter_new_hit > 0: # update timestamp
                        color_font = 'blue'
                        update = 'yes'
                        with open(jsonfile_last_path, 'r') as json_file_last:
                            data = json.load(json_file_last)
                            for item in data['acls']:
                                if pnew['from'] == plast['from'] and pnew['to'] == plast['to'] and pnew['name'] == plast['name']:
                                    item['timestamp'] = str(new_datetime)
                                    print('[updating last update timestamp] '+pnew['from']+' '+pnew['to'] + \
                                    ' '+pnew['name']+' increment +'+pnew['count']+' last timestamp:'+str(last_datetime)+' new timestamp:'+str(new_datetime))
                                    elapsed_time = ''
                                    break
                        json_file_last.close()

                        with open(jsonfile_last_path, 'w') as json_file_last:
                            json.dump(data, json_file_last, indent=4)
                        json_file_last.close()

                    elif counter_new_hit < 0:

                        # REINIT FILE SINCE HITCOUNT HAS BEEN REST
                        jsonfile_rewrite = open(jsonfile_last_path, 'w')
                        json.dump(data_new, jsonfile_rewrite, indent=4)
                        jsonfile_rewrite.close()
                        reset = True

                    else:

                        if elapsed_time > datetime.timedelta(days=90) and \
                        not pnew['name'] == 'default-deny':
                            error_summary = 1
                            error_acl = 1
                            comment_elapsed = 'not updated since more than 90 days'

                    if prev_from == pnew['from'] and prev_to == pnew['to']:
                        color_cell = '#FFFFFF'
                        tablecontent += '<tr>'
                        tablecontent += '<td>'+pnew['index']+'</td>'
                        tablecontent += '<td><center>|</center></td>'
                        tablecontent += '<td><center>|</center></td>'
                    else:
                        tablecontent += '<tr bgcolor="#E6F2FF">'
                        tablecontent += '<td>'+pnew['index']+'</td>'
                        tablecontent += '<td>'+pnew['from']+'</td>'
                        tablecontent += '<td>'+pnew['to']+'</td>'
                        color_cell = '#E6F2FF'
                
                    tablecontent += '<td>'+pnew['name']+'</td>'
                    if pnew['count'] == '0' and counter_new_hit == 0:
                        for acl in acl_list:
                            if (minion == acl['minion'] and pnew['from'] == acl['from'] and \
                            pnew['to'] == acl['to'] and pnew['name'] == acl['name']):
                                exceptions_match = 'match'
                        
                        if not exceptions_match: 

                            if pnew['name'] == 'default-deny':
                                color_font = 'orange'
                                comment = 'never used'                                
                            else:
                                comment = 'never matched'
                                if comment_elapsed:
                                    error_summary = 1
                                    error_acl = 1
                                    color_cell = 'red'
                                    color_font = 'white'
                                else:
                                    color_font = 'orange'                                    
                        else:
                            color_cell = 'blue'
                            color_font = 'white'
                            comment = 'exception'                                
                        tablecontent += '''<td bgcolor=%s><b><font color=%s>%s (+%d) %s</font></b></td>''' % (color_cell, color_font, pnew['count'], counter_new_hit, comment)
                    else:
                        tablecontent += '''<td bgcolor=%s><font color=%s>%s (+%d)</font></td>''' % (color_cell, color_font, pnew['count'], counter_new_hit)
                    
                    if update == 'yes':
                        tablecontent += '<td>'+pnew['timestamp'].split('.')[0]+'</td>'
                        color_font = 'blue'
                    elif update == 'no':
                        tablecontent += '<td>'+plast['timestamp'].split('.')[0]+'</td>'
                        color_font = 'black'                        

                    if comment_elapsed:
                        error_summary = 1
                        color_cell = 'orange'
                        color_font = 'white'
                        tablecontent += '''<td align="right" bgcolor=%s><font color=%s>%s %s</font></td>''' % (color_cell, color_font, str(elapsed_time).split('.')[0], comment_elapsed)
                    else:
                        tablecontent += '''<td align="right"><font color=%s>%s</font></td>''' % (color_font, str(elapsed_time).split('.')[0])
                    tablecontent += '</tr>\n        '


                    if error_acl:
                        mop += '<tr><td colspan="7">delete security policies from-zone '+pnew['from']+' to-zone '+pnew['to']+' policy '+pnew['name']+'</td></tr>'

                    prev_from = pnew['from']
                    prev_to = pnew['to']

        if not error_summary:
            mop = '<tr><td><font color=green><b>no error detected</b></font></td></tr>'
            htmlerrorcode = 'noerror' 
        else:
            htmlerrorcode = 'error'   

        subject = '[hit counter '+minion+']'

        if reset:
            htmlerrorcode = 'error' 
            htmlmsg = """
            <html>
            <!--%s|%s-->
            <head></head>
            <body>
            <table border=0>
                <th bgcolor="#B40404" align=center colspan="7"><font color=white><b>%s - last audit %s</b></font></th>              
                <tr>
                    <td colspan=7><b><font color=red>Policies hitcount reset has been detected, pending next Salt audit</b></font></td>
                </tr>
            </table>
            </body>
            </html>                
            """ % (htmlerrorcode, str(datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")), minion, str(datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")))
        else:
            htmlmsg = """
            <html>
            <!--%s|%s-->
            <head></head>
            <body>
            <table border=0>
                <th bgcolor="#B40404" align=center colspan="7"><font color=white><b>%s - last audit %s</b></font></th>
                <tr bgcolor="#F0F0F5">
                    <td align=center colspan="7"><b>cleanup command(s)</b></td>
                </tr>
                %s
                <tr bgcolor="#F0F0F5">
                    <td><b>Index</b></td>
                    <td><b>From zone</b></td>
                    <td><b>To zone</b></td>
                    <td><b>Policy name</b></td>
                    <td><b>Count</b></td>
                    <td><b>Last update</b></td>
                    <td><b>Elapsed time (<font color=orange>warning</font> if > 90 days)</b></td>
                </tr>
                %s
            </table>
            </body>
            </html>
        """ % (htmlerrorcode, str(datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")), minion, str(datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")), mop, tablecontent)
    
    return htmlmsg, subject, error_summary 


def upload_atlnetutil01(htmlmsg, minion):

    # write in file
    sv = open('/var/audits/firewalls/'+minion, 'w')
    sv.write(htmlmsg)
    sv.close()

    # copy the file to atlnetutil01

    command = 'scp /var/audits/firewalls/{minion} opsnetwork@nio.arkadin.lan:/home/opsnetwork/atlnetutil01/inventory/audits/firewalls/{minion}'.format(minion=minion)
    os.system(command)
    log.warning(minion+' data copy on atlnetutil01')
    log.critical('end')

    return True

def notification(htmlmsg, subject, minion):
    # add line to remote log
    log_message = 'error|'+str(datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S"))+'|policy warning has been detected for <a href=https://nio.arkadin.lan:8081/inventory/audits/firewalls/'+minion+' target="_blank">'+minion+'</a>'
    os.system('echo \''+log_message+'\' | ssh opsnetwork@nio.arkadin.lan "cat >> /home/opsnetwork/atlnetutil01/atlnetutil01.log"')

    fromsrc = 'salt-master@arkadin.com'
    destination = 's.klamm@arkadin.com'
    recipients = ['s.klamm@arkadin.com']

    msg = MIMEMultipart()
    msg['Subject'] = subject
    msg['From'] = fromsrc
    msg['To'] = destination

    part1 = MIMEText(htmlmsg, 'html')
    msg.attach(part1)

    s = smtplib.SMTP('smtp.arkadin.lan')
    s.sendmail(fromsrc, recipients, msg.as_string())
    s.quit()

    return True
