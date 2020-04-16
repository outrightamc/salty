import subprocess
import salt.modules.smtp
import salt.config
import salt.runner
import salt.client
import logging
log = logging.getLogger(__name__)
from shutil import copyfile
import re

def email_failure(fromaddr, toaddrs, subject, data_str, smtp_server):

      data = eval(data_str)
      error = False
      changes = False

      if type(data['return']) is dict:
            for state, result in data['return'].items():
                  if not result['result']:
                        error = True
                        break
                  if result['changes']:
                        changes = True
                        break
      else:
            if not data['success']:
                  error = True

      if error:
            body = subprocess.check_output(["salt-run", "jobs.lookup_jid", data['jid']])
            salt.modules.smtp.send_msg(\
                  toaddrs,\
                  body,\
                  subject=subject,\
                  sender=fromaddr,\
                  server=smtp_server,\
                  use_ssl=True)
      return True

def email_change(fromaddr, toaddrs, subject, data_str, smtp_server):

      data = eval(data_str)
      error = False
      changes = False

      if type(data['return']) is dict:
            for state, result in data['return'].items():
                  if not result['result']:
                        error = True
                        break
                  if result['changes']:
                        changes = True
                        break
      else:
            if not data['success']:
                  error = True

      if changes:
            body = subprocess.check_output(["salt-run", "jobs.lookup_jid", data['jid']])
            salt.modules.smtp.send_msg(\
                  toaddrs,\
                  body,\
                  subject=subject,\
                  sender=fromaddr,\
                  server=smtp_server,\
                  use_ssl=True)
      return True

def parse_job_output(data_str):
      data = eval(data_str)
      buffers_folder_path = '/srv/salt/buffers/'
      backups_folder_path = '/srv/salt/backups/'

      opts = salt.config.master_config('/etc/salt/master') # define salt runner opts
      runner = salt.runner.RunnerClient(opts)
      client = salt.client.LocalClient(__opts__['conf_file']) # define salt client opts

      job_output = runner.cmd('jobs.lookup_jid', [data['jid']]) # collect job output

      if data['schedule'] == 'collect_configuration' and data['fun'] == 'net.config' : # if output is net.config schedule

            pillar = runner.cmd('pillar.show_pillar', [data['id']])
            driver = pillar['proxy']['driver']
            os_commands = pillar['backup'][driver]    
            
            if driver == 'ios' or driver == 'nxos_ssh':
                  startup_cfg = job_output[data['id']]['out']['startup']

            elif driver == 'junos':
                  startup_cfg = job_output[data['id']]['out']['candidate']

            if startup_cfg: # if config was parsed successfully

                  filtered_startup = _filter_lines(startup_cfg, [
                        '^Building configuration\.\.\.$',
                        '^version\s.*$',
                        '^Current configuration\s*:\s*\d+ bytes$',
                        '^\S+#\^@$',
                        '^\s*$',
                        '^##\sLast\schanged.*$'                       
                  ])
                  buffer_file_path = buffers_folder_path+data['id']
                  raw_file_path = backups_folder_path+'raw_'+data['id']
                  buffer_file = open(buffer_file_path, 'w') # create cfg file
                  raw_file = open(raw_file_path, 'w') # create raw cfg file

                  for cmd in os_commands:
                        minion_cmd = client.cmd(data['id'], 'net.cli', [cmd], timeout=10)
                        filtered_minion_cmd = _filter_lines(minion_cmd[data['id']]['out'][cmd], [
                              '^Building configuration\.\.\.$',
                              '^Current configuration\s*:\s*\d+ bytes$',
                              '^\S+#\^@',
                              '^\s*$',
                              '^##\sLast\schanged.*$'
                        ])
                        buffer_file.write('\n['+cmd.upper()+']\n')
                        buffer_file.write(_filter_common_diff(filtered_minion_cmd+'\n'))

                  buffer_file.write('\n[STARTUP CONFIGURATION]\n')
                  buffer_file.write(_filter_common_diff(filtered_startup)) # write configuration in file
                  buffer_file.close() # close backup file
                  raw_file.write(_filter_common_diff(filtered_startup)) # write raw
                  raw_file.close() # close raw backup file

                  # write buffer file in backup folder
                  backup_file_path = backups_folder_path+data['id']
                  copyfile(buffer_file_path, backup_file_path)
      return True

def _filter_common_diff(output):
      filtered_output = ''
      split_output = output.splitlines()
      for line in split_output:
            if ('uptime is' in line or line.startswith('System restarted at') or
            line.startswith('uptime') or line.startswith('Uptime') or
            line.startswith('Uptime') or line.startswith('Time') or line.startswith('!Time')):
                  filtered_output += '*** LINE FILTERED BY SALTSTACK TO AVOID DIFFERENTIAL (UPTIME) ***\n'
            elif 'password 7' in line:
                  filtered_output += '*** UNPROTECTED PASSWORD 7 - FILTERED ***\n'
            else:
                  filtered_output += line+'\n'
      return filtered_output

def _filter_lines(config, filters):
    out_lines = []
    compiled_filters = [re.compile(i) for i in filters]
    for l in config.split('\n'):
        filter_line = False
        for f in compiled_filters:
            if f.match(l):
                filter_line = True
        if not filter_line:
            out_lines.append(l)
    return '\n'.join(out_lines)
