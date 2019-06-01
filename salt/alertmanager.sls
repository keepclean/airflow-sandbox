
{%- set version = "0.17.0" %}
install alertmanager:
  archive.extracted:
    - name: /srv/alertmanager/{{ version }}
    - source: https://github.com/prometheus/alertmanager/releases/download/v{{ version }}/alertmanager-{{ version }}.linux-amd64.tar.gz
    - source_hash: https://github.com/prometheus/alertmanager/releases/download/v{{ version }}/sha256sums.txt
    - options: --directory /srv/alertmanager/{{ version }} --strip-components=1
    - enforce_toplevel: False
    - user: prometheus
    - group: prometheus
    - require:
      - add prometheus user

symlink current directory to alertmanager version:
  file.symlink:
    - name: /srv/alertmanager/current
    - target: /srv/alertmanager/{{ version }}
    - user: prometheus
    - group: prometheus
    - require:
      - add prometheus user

alertmanager systemd service:
  file.managed:
    - name: /etc/systemd/system/alertmanager.service
    - source:
      - salt://templates/alertmanager.service
    - require:
      - symlink current directory to alertmanager version

run alertmanager service:
  service.running:
    - name: alertmanager.service
    - enable: True
    - no_block: True
    - require:
      - alertmanager systemd service