import logging
import salt.utils.yaml


def returner(ret):
    log = logging.getLogger(__name__)

    returns = [(k, v) for k, v in ret["return"].items()]

    message = """
{}\r
{} - {}\r
=======\r
{}\r\n""".format(
        ret["id"],
        ret["fun"],
        salt.utils.yaml.safe_dump(returns),
    )

    teams_hook = __pillar__.get("msteams_hook_url")
    log.debug("msteams: found hook url {}".format(teams_hook))

    result = __salt__["msteams.post_card"](message=message, hook_url=teams_hook)
    log.debug("msteams: result {}".format(result))
