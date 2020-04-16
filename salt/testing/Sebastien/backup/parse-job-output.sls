{% if data['schedule'] is defined %}
  {% if data['schedule'] == 'collect_configuration' %}
  parse-job-output:
    runner.process_minion_data.parse_job_output:
      - data_str: {{ data|yaml_dquote }}
  {% elif data['schedule'] == 'backup_sync' %}
  backup-sync:
    runner.backup_sync.push:
      - data_str: {{ data|yaml_dquote }}
  {% elif data['schedule'] == 'firewall' %}
  firewall-audit:
    runner.firewall.hitcount:
      - data_str: {{ data|yaml_dquote }}
  {% elif data['schedule'] == 'bgp' %}
  check-bgp-down:
    runner.bgp.checkdown:
      - data_str: {{ data|yaml_dquote }}
  {% endif %}
{% endif %}