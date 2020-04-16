custom_napalm_installed:
  file.recurse:
    - name: /usr/lib/python3.6/site-packages/custom_napalm
    - source: salt://server/salt/custom_napalm
    - clean: true
