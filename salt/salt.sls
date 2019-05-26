disable salt-minion service:
  service.dead:
    - name: salt-minion
    - enable: False

