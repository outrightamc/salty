schedule:
  firewall:
    function: net.connected
    when:
      - Monday 10:00pm
      - Tuesday 10:00pm
      - Wednesday 10:00pm
      - Thursday 10:00pm
      - Friday 10:00pm
      - Saturday 10:00pm
      - Sunday 10:00pm
    splay: 20
