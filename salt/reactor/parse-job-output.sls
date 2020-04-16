{# do salt.log.error('reactor parse-job-output.sls triggered') #} # DEBUG
{% if data['schedule'] is defined %}
  {%- do salt.log.error('data[schedule] is defined') -%}
  {% if data['schedule'] == 'firewall' %}
  firewall-audit:
    runner.firewall.hitcount:
      - data_str: {{ data|yaml_dquote }}
  {% elif data['schedule'] == 'bgp' %}
  check-bgp-down:
    runner.bgp.checkdown:
      - data_str: {{ data|yaml_dquote }}
  {% endif %}
{% else %}
  {# do salt.log.error('data[schedule] is NOT defined DATA:'~data|string) #}
  {% if data['fun'] is defined %}
    {% if data['fun'] == 'schedule.run_job' %}
      {% if data['fun_args'][0] == 'firewall' %}
      firewall-audit:
        runner.firewall.hitcount:
          - data_str: {{ data|yaml_dquote }}
      {% elif data['fun_args'][0] == 'bgp' %}
      check-bgp-down:
        runner.bgp.checkdown:
          - data_str: {{ data|yaml_dquote }}
      {% endif %}
    {% endif %}
  {% endif %}
{% endif %}