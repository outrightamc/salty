{%- for u in salt.pillar.get('local_users:present', []) %}
        {%- if u.neteng_class is defined and u.neteng_class != false %}

                {%- if u.neteng_class == 'super-user' %}
                        {%- set groups = ['sudo', 'netedit'] %}
                {%- elif u.neteng_class == 'read-only' %}
                        {%- set groups = ['netshow'] %}
                {%- endif %}

{{ u.username }}:
  user.present:
    - fullname: {{ u.fullname }}
    - password: {{ u.password }}
    - shell: {{ u.shell|default('/bin/bash') }}
    - groups: {{ groups }}

        {%- else %}

{{ u.username }}:
  user.absent

        {%- endif %}
{%- endfor %}

{%- for u in salt.pillar.get('local_users:absent', []) %}
{{ u }}:
  user.absent
{%- endfor %}

rancid:
  user.present:
    - fullname: Rancid Config Backup
    - password: {{ salt.pillar.get('local_users:backup_password') }}
    - shell: "/bin/bash"
    - groups:
      - sudo
      - netedit
