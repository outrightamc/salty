import salt.modules.smtp
import git
from git import Repo
import logging
log = logging.getLogger(__name__)
import datetime, os

def push(data_str):
      data = eval(data_str)
      backups_folder_path = '/srv/salt/backups'

      # copy files to atlnetutil01
      backup_files = os.listdir(backups_folder_path)
      for backup_file in backup_files:
            if not backup_file.startswith('.') and not backup_file == 'README.md':
                 os.system('cat '+backups_folder_path+'/'+backup_file+' | ssh opsnetwork@nio.arkadin.lan "cat > /home/opsnetwork/atlnetutil01/inventory/backups/'+backup_file+'"')

      '''# github configuration sync
      repo = git.Repo(backups_folder_path) # define repository path
      repo.git.add(backups_folder_path) # add whole folder
      repo.git.commit('-m', 'updated by SaltStack') # commit
      repo.git.push('origin', 'master') # push

      commits_history = list(repo.iter_commits(paths=backups_folder_path))
      diff = repo.git.diff(commits_history[1], commits_history[0], backups_folder_path)

      if diff:
            email_diff(diff)
            # add line to remote log
            log_message = 'github|'+str(datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S"))+'|change(s) have been synchronized for '+data['id']+' to <a href=https://github.com/arkadin-nio/backups/commit/'+str(commits_history[0])+' target="_blank">Github (commit ID '+str(commits_history[0])+')</a>'
            os.system('echo \''+log_message+'\' | ssh opsnetwork@nio.arkadin.lan "cat >> /home/opsnetwork/atlnetutil01/atlnetutil01.log"')
      '''
      return True

def email_diff(diff):
      salt.modules.smtp.send_msg(\
            'Network_Infrastructure_Operations@arkadin.com',\
            diff,\
            subject='Differential backup',\
            sender='salt-master@arkadin.com',\
            server='127.0.0.1',\
            use_ssl=True)                   
      return True
