email-on-change:
  runner.process_minion_data.email_change:
    - smtp_server: 127.0.0.1
    - fromaddr: salt-master@arkadin.com
    - toaddrs: s.klamm@arkadin.com
    - subject: "Minion change: {{ data['id'] }} jid: {{ data['jid'] }}"
    - data_str: {{ data|yaml_dquote }}