def merged_config():
    services = []
    services.append(__salt__['peering.private_peering']())
    services.append(__pillar__.get('static', {}).copy())

    merged = {}
    for s in services:
        merged = __salt__['slsutil.merge'](merged, s, merge_lists=True)

    return merged
