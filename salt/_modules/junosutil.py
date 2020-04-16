import collections
import json
import jxmlease


def ordered_config_json():
    return json.dumps(ordered_config())


def ordered_config_xml():
    return jxmlease.emit_xml(ordered_config())


def ordered_config():
    config_data = __pillar__.get("configuration")
    out = {"configuration": reorder_junos_statements(config_data)}
    return out


def reorder_junos_statements(raw):
    out = collections.OrderedDict()
    if "@" in raw:
        out["@"] = raw.pop("@")
    if "name" in raw:
        out["name"] = raw.pop("name")
    for k, v in list(raw.items()):
        if isinstance(v, dict):
            out[k] = reorder_junos_statements(v)
        elif isinstance(v, list):
            out[k] = []
            for i in v:
                if isinstance(i, dict):
                    out[k].append(reorder_junos_statements(i))
                else:
                    out[k].append(i)
        else:
            out[k] = v
    return out
