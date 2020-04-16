#!py
def run():
    with open("/var/log/salt/minion-auth.log", "a+") as authlog:
        authlog.write(
            "timestamp={} minion={} result={}\n".format(
                data["_stamp"], data["id"], data["act"]
            )
        )
    return {}
