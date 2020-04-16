{# define Juniper template include paths #}
{% set multi = 'network.general.multi.' %}
{% set juniper = 'network.general.juniper.' %}

{# define Juniper template per section #}
{% set junos_sections = {

  'version' : juniper~'version',
  'system.login' : juniper~'login',
  'system.services' : juniper~'services',
  'system.processes' : juniper~'processes',
  'chassis' : juniper~'chassis',
  'policy-options' : juniper~'policy-options',
  'firewall' : juniper~'firewall',
  'interfaces' : juniper~'interfaces',
  'lldp' : juniper~'lldp',
  'snmp' : multi~'snmp',
  'system.ntp' : multi~'ntp',
  'routing-options' :  juniper~'routing-options',
  'protocols' : juniper~'protocols',
  'firewall.edge-filter' : juniper~'edge-filter',
  'routing-instances' : juniper~'routing-instances'
}
%}

{# Templates removed to avoid error message #}
{# 'system.syslog' : multi~'syslog' #}
{#  #}
{#  #}

{# include each section templates to build full configuration #}
include:
{% for include_section in junos_sections.keys() %}
  - {{ junos_sections[include_section] }}
{% endfor %}
