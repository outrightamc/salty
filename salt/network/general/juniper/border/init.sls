{# define Juniper template include paths #}
{% set multi = 'network.general.multi.' %}
{% set juniper = 'network.general.juniper.' %}

{# define Juniper template per section within a tuple #}
{% set sections = (
  juniper~'login',
  juniper~'services',
  multi~'syslog',
  juniper~'processes',
  multi~'ntp',
  juniper~'chassis',
  juniper~'router-oam',
  juniper~'routing-instances',
  juniper~'interfaces',
  multi~'snmp',
  juniper~'routing-options',
  juniper~'protocols',
  juniper~'edge-filter',
  juniper~'policy-options'
)
%}

{# include each section templates to build full configuration #}
include:
{% for section in sections %}
  - {{ section }}
{% endfor %}
