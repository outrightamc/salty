{# NAPALM-LOGS EVENT #}
{% set event = data.error %}
{# HOSTNAME #}
{% set host = data.message_details.host %}
{# MESSAGE #}
{% set message = data.message_details.message %}

{# EVENTS NAME #}

{# CONFIGURATION_COMMIT_REQUESTED #}
{% if event == 'CONFIGURATION_COMMIT_REQUESTED' %}
  {% set definition = 'configuration commit requested' %}
  {% set runner_data = salt['saltutil.runner'](name='junos.compare_rollbacks', arg=[host]) %}
  {% set send_data = salt['saltutil.runner'](name='atlnetutil01.send_data', arg=[data, runner_data]) %}
  {# set runner_msteams = salt['saltutil.runner'](name='msteams.send_message', arg=[definition, host, message, runner_compare]) #}

{# BGP_NEIGHBOR_STATE_CHANGED #}
{% elif event == 'BGP_NEIGHBOR_STATE_CHANGED' %}
  {% set definition = 'BGP neighbor state changed' %}
  {% set runner_data = salt['saltutil.runner'](name='junos.get_bgp_data', arg=[host, data]) %}
  {% set send_data = salt['saltutil.runner'](name='atlnetutil01.send_data', arg=[data, runner_data]) %}
  {# set runner_msteams = salt['saltutil.runner'](name='msteams.send_message', arg=[definition, host, message, runner_data]) #}
  
{# INTERFACE_DOWN #}
{% elif event == 'INTERFACE_DOWN' %}
  {% set definition = 'interface down' %}
  {% set runner_data = salt['saltutil.runner'](name='junos.get_itf_data', arg=[host, data]) %}
  {% if not runner_data == 'skip' %}
    {% set send_data = salt['saltutil.runner'](name='atlnetutil01.send_data', arg=[data, runner_data]) %}
    {# set runner_msteams = salt['saltutil.runner'](name='msteams.send_message', arg=[definition, host, message, runner_data]) #}
  {% endif %}

{# BGP_SESSION_NOT_CONFIGURED #}
{% elif event == 'BGP_SESSION_NOT_CONFIGURED' %}
  {% set definition = 'BGP session not configured' %}
  {% set send_data = salt['saltutil.runner'](name='atlnetutil01.send_data', arg=[data, none]) %}
{% endif %}
