{% for u in salt.pillar.get('local_users:present', []) %}
  {%- if u.salt_id is defined and grains.id in u.salt_id %}
{{ u.username }}:
  user.present:
    - fullname: {{ u.fullname }}
    - password: {{ u.password }}
    - shell: {{ u.shell|default('/bin/bash') }}
    - optional_groups: {{ u.groups }}
    {%- if u.expiry is defined %}
    - expire: {{ u.expiry }}
    {%- endif %}
    {% if u.authorized_keys|length > 0 %}
{{ u.username }}_keys:
  ssh_auth.present:
    - user: {{ u.username }}
    - names: {{ u.authorized_keys }}
    {% endif %}
  {%- elif u.salt_id is not defined %}
{{ u.username }}:
  user.present:
    - fullname: {{ u.fullname }}
    - password: {{ u.password }}
    - shell: {{ u.shell|default('/bin/bash') }}
    - optional_groups: {{ u.groups }}
    {%- if u.authorized_keys|length > 0 %}
{{ u.username }}_keys:
  ssh_auth.present:
    - user: {{ u.username }}
    - names: {{ u.authorized_keys }}
    {%- endif %}
  {%- endif %}
{% endfor %}

{% for u in salt.pillar.get('local_users:absent', []) %}
{{ u }}:
  user.absent
{% endfor %}
