def sampling():
    '''
    Provide a dict of the connected interfaces and their ip4 addresses
    The addresses will be passed as a list for each interface
    '''
    # Provides:
    #   ip_interfaces

    if salt.utils.platform.is_proxy():
        return {}

    ret = {}
    ifaces = _get_interfaces()
    for face in ifaces:
        iface_ips = []
        for inet in ifaces[face].get('inet', []):
            if 'sampling' in inet:
                iface_ips.append(inet['sampling'])
        ret[face] = iface_ips
    return {'sampling': ret}
