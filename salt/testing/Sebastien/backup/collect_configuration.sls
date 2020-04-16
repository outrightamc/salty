schedule:
  collect_configuration:
    function: net.config
    when:
      - Monday 09:00pm
      - Tuesday 09:00pm
      - Wednesday 09:00pm
      - Thursday 09:00pm
      - Friday 09:00pm
      - Saturday 09:00pm
      - Sunday 09:00pm
    splay: 20