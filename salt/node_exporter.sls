{%- set version = "0.18.0" %}
install node_exporter:
  archive.extracted:
    - name: /srv/prometheus-node_exporter/{{ version }}
    - source: https://github.com/prometheus/node_exporter/releases/download/v{{ version }}/node_exporter-{{ version }}.linux-amd64.tar.gz
    - source_hash: https://github.com/prometheus/node_exporter/releases/download/v{{ version }}/sha256sums.txt
    - options: --directory /srv/prometheus-node_exporter/{{ version }} --strip-components=1
    - enforce_toplevel: False
    - user: prometheus
    - group: prometheus
    - require:
      - add prometheus user

symlink current directory to node_exporter version:
  file.symlink:
    - name: /srv/prometheus-node_exporter/current
    - target: /srv/prometheus-node_exporter/{{ version }}
    - user: prometheus
    - group: prometheus
    - require:
      - add prometheus user

node_exporter systemd service:
  file.managed:
    - name: /etc/systemd/system/node_exporter.service
    - source:
      - salt://templates/node_exporter.service
    - require:
      - add prometheus user
      - symlink current directory to node_exporter version

run node_exporter service:
  service.running:
    - name: node_exporter.service
    - enable: True
    - no_block: True
    - require:
      - node_exporter systemd service