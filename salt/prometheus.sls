{%- set version = "2.10.0" %}
install prometheus {{ version }}:
  archive.extracted:
    - name: /srv/prometheus/{{ version }}
    - source: https://github.com/prometheus/prometheus/releases/download/v{{ version }}/prometheus-{{ version }}.linux-amd64.tar.gz
    - source_hash: https://github.com/prometheus/prometheus/releases/download/v{{ version }}/sha256sums.txt
    - options: --directory /srv/prometheus/{{ version }} --strip-components=1
    - enforce_toplevel: False
    - user: prometheus
    - group: prometheus
    - require:
      - add prometheus user

symlink current directory to prometheus version:
  file.symlink:
    - name: /srv/prometheus/current
    - target: /srv/prometheus/{{ version }}
    - user: prometheus
    - group: prometheus
    - require:
      - add prometheus user

add prometheus user:
  user.present:
    - name: prometheus
    - shell: /bin/false
    - home: /srv/prometheus
    - system: True

prometheus systemd service:
  file.managed:
    - name: /etc/systemd/system/prometheus.service
    - source:
      - salt://templates/prometheus.service
    - require:
      - add prometheus user
      - symlink to current directory

run prometheus service:
  service.running:
    - name: prometheus.service
    - enable: True
    - no_block: True
    - require:
      - prometheus systemd service