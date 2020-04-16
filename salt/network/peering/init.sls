# this is a meta state to run the required peering states
{%- if 'mpls_pe' in pillar.roles %}
include:
- network.general.multi.policy-options
- network.general.multi.routing-instances
- network.general.multi.interfaces
{%- endif %}
{%- if 'edge_switch' in pillar.roles %}
include:
- network.general.multi.vlans
- network.general.multi.interfaces
{%- endif %}
