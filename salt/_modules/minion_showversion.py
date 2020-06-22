import getpass
import logging
import sys
import salt.client
import salt.log

salt.log.setup_console_logger()
logger = logging.getLogger(__name__)
logger.setLevel(logging.WARN)

try:
	master_client = salt.client.LocalClient()
	result = master_client.cmd('vsrx1', 'net.cli', ['show system uptime'], username='saltapi', password='saltapi', eauth='pam')
except salt.exceptions.EauthAuthenticationError:
	logger.fatal("Could not authenticate with master")
	cur_user = getpass.getuser()
	if cur_user != 'root':
		logger.fatal("Trying running as root (sudo)")
	sys.exit(1)

#for min in all_minions:
print (result)
#	for user in all_minions[min]:
#		if user.startswith('a'):
#			print (" ", minion)
