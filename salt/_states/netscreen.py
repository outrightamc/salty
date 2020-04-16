def blacklist_managed(name="", tgt=".*", blacklist=[], *args, **kwargs):
    ''' Manage Netscreen edge filter blacklist state. '''

    # first compile what the desired configuration is.
    target_blacklist = []
    blacklist_info = {}
    for prefix in blacklist:
        if "/" not in prefix:
            pfx = prefix
            length = 32
        else:
            pfx, length = prefix.split("/")

        obj_name = "ADDR_BL-{}-{}".format(pfx, length)
        blacklist_info[obj_name] = {"prefix": pfx, "length": length}
        target_blacklist.append(obj_name)

    # initialise the output dict
    out = {"name": name, "result": None, "changes": {}, "comment": ""}

    # get current blacklist and process changes
    failed = False
    for host, data in __salt__["netscreen.get_blacklist"](tgt).items():
        result = __salt__["iosutil.list_diff"](data["members"], target_blacklist)

        # if already in state move onto next host
        if len(result["remove"]) == 0 and len(result["add"]) == 0:
            out["changes"][host] = {}
            continue

        # render the config required in order to bring host into state
        cmd_set = []
        for obj in result["remove"]:
            cmd_set.append(
                "unset group address Untrust PFX_BLACKLIST_V4 add {}".format(obj)
            )
        for obj in result["add"]:
            cmd_set.append(
                "set address Untrust {} {}/{}".format(
                    obj, blacklist_info[obj]["prefix"], blacklist_info[obj]["length"]
                )
            )
            cmd_set.append(
                "set group address Untrust PFX_BLACKLIST_V4 add {}".format(obj)
            )
        out["changes"][host] = cmd_set

        if not __opts__["test"]:
            # send commands to host
            __salt__["netscreen.cli"](host, cmd_set)

            # check that blacklist is now in state
            data = __salt__["netscreen.get_blacklist"](host)[host]
            result = __salt__["iosutil.list_diff"](data, target_blacklist)
            if len(result["remove"]) == 0 and len(result["add"]) == 0:
                out["result"] = True
                out["comment"] += "{} updated successfully.\n".format(host)
                __salt__["netscreen.cli"](host, "save")
            else:
                failed = True
                out["comment"] += "{} changes failed.\n".format(host)

    # if one of the hosts has failed mark the whole state as failed
    if failed:
        out["result"] = False
    out["comment"] = out["comment"].strip()
    return out
