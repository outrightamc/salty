junos_native_configured:
  netconfig.managed:
    - template_name: salt://network/junos/native_yang.j2
    - replace: true
