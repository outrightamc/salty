schedule:
  backup_sync:
    function: test.ping
    when:
      - Monday 11:00pm
      - Tuesday 11:00pm
      - Wednesday 11:00pm
      - Thursday 11:00pm
      - Friday 11:00pm
      - Saturday 11:00pm
      - Sunday 11:00pm
