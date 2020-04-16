import netaddr


def ipnetwork(address):
    ip = netaddr.IPNetwork(address)
    return {'ip': str(ip.ip), 'netmask': str(ip.netmask), 'addresses': [str(adr) for adr in ip]}
