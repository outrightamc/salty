import os, re, datetime
import salt.client
import salt.runner
import salt.config
import smtplib
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
from email.mime.application import MIMEApplication
from email.mime.image import MIMEImage

def checkdown(data_str):
    data = eval(data_str)
    minion = data['id']
    output_table = []
    htmlmsg = ''
    tablecontent = ''
    error = None
    htmlerrorcode = 'noerror'
    peer_list = ''
    comment = ''

    local = salt.client.LocalClient()
    opts = salt.config.master_config('/etc/salt/master') # define salt runner opts
    runner = salt.runner.RunnerClient(opts)
    neighbors = local.cmd(minion, 'bgp.neighbors')
    routinginstances = neighbors[minion]['out']

    if routinginstances:
        for ri in routinginstances:
            for asn_list in list(routinginstances[ri].items()):
                for peer in asn_list[1]:
                    exceptions_match = None
                    comment = '' # reset
                    fontcolor = 'black'
                    entry = [
                        peer['routing_table'], asn_list[0], peer['remote_address'],
                        peer['connection_state'], peer['import_policy'] + ' / ' + peer['export_policy']
                    ]

                    pattern = re.compile("^(Active|Connect|Idle.*)$")
                    if pattern.match(peer['connection_state']):                    
                        # check if exception
                        pillar = runner.cmd('pillar.show_pillar', [minion])
                        peer_list = pillar['bgp_exceptions']['peer']

                        for p in peer_list:
                            if (p['minion'] == minion and p['ASN'] == str(asn_list[0]) and
                            p['routing_table'] == peer['routing_table'] and 
                            p['remote_address'] == peer['remote_address']):
                                exceptions_match = 'match'

                        if not exceptions_match:
                            tablecontent += '<tr bgcolor=red>'
                            error = 'error_detected'
                            htmlerrorcode = 'error'
                            fontcolor = 'white'
                        else:
                            tablecontent += '<tr bgcolor=blue>'
                            fontcolor = 'white'
                            comment = '<b>(exception)</b>'

                    elif peer['connection_state'] == 'Established':
                        tablecontent += '<tr>'

                    output_table.append(entry)    
                    tablecontent += '''<td><font color=%s>%s</font></td>''' % (fontcolor, peer['routing_table'])
                    tablecontent += '''<td><font color=%s>%s</font></td>''' % (fontcolor, str(asn_list[0]))
                    tablecontent += '''<td><font color=%s>%s %s</font></td>''' % (fontcolor, peer['remote_address'], comment)
                    tablecontent += '''<td><font color=%s>%s</font></td>''' % (fontcolor, peer['connection_state'])
                    tablecontent += '''<td><font color=%s>%s / %s</font></td>''' % (fontcolor, peer['import_policy'], peer['export_policy'])
                    tablecontent += '</tr>\n'            

    if not output_table:
        htmlerrorcode = 'nopeering'
        tablecontent += '<tr><td colspan=5><font color=blue><b>no BGP peerings detected</b></font></td></tr>'

    htmlmsg = """
	<html>
    <!--%s|%s-->
	<head></head>
	<body>
    <table border=0>
        <th bgcolor="#B40404" align=center colspan="5"><font color=white><b>%s - last BGP audit %s</b></font></th>
        <tr bgcolor="#F0F0F5">
        	<td><b>Instance</b></td>
        	<td><b>ASN</b></td>
            <td><b>Peer IP</b></td>
            <td><b>State</b></td>
            <td><b>Import/Export</b></td>
        </tr>
        %s
    </table>
	</body>
	</html>
""" % (
        htmlerrorcode,
        str(datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")),
        minion, str(datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")),
        tablecontent
    )
    
    upload_atlnetutil01(htmlmsg, minion)

    #if error:
    #   notification(htmlmsg, minion)

    return True

def upload_atlnetutil01(htmlmsg, minion):
    # copy the file to atlnetutil01
    os.system('echo \''+htmlmsg+'\' | ssh opsnetwork@nio.arkadin.lan "cat > /home/opsnetwork/atlnetutil01/inventory/audits/bgp/'+minion+'"')
    

def notification(htmlmsg, minion):
    subject = '[bgp audit '+minion+']'
    # add line to remote log
    log_message = 'error|' + str(datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")) + '|bgp peer down detected for <a href=https://nio.arkadin.lan:8081/inventory/audits/bgp/'+minion+' target="_blank">'+minion+'</a>'
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
