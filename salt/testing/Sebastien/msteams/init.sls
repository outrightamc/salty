{% set username = opts['user'] %}

# Notify NIO that this state has been executed
nio/msteams/border:
  event.send:
    - data:
        status: "nio/msteams/border state has been executed by {{ username }}"
        test: 'test var'
