add airflow user:
  user.present:
    - name: airflow
    - home: /srv/airflow
    - shell: /bin/bash

airflow sudo file:
  file.managed:
    - name: /etc/sudoers.d/airflow
    - source:
      - salt://templates/airflow.sudoers
    - mode: 440
    - require:
      - add airflow user

create airflow virtualenv:
  virtualenv.managed:
    - name: /srv/airflow
    - python: python3
    - user: airflow
    - requirements: salt://templates/airflow-requirements.txt
    - require:
      - add airflow user

airflow config file:
  file.managed:
    - name: /srv/airflow/airflow.cfg
    - source:
      - salt://templates/airflow.cfg
    - user: airflow
    - group: airflow

init airflow db:
  cmd.run:
    - name: airflow initdb
    - runas: airflow
    - onlyif: psql -l airflow | grep -q airflow
    - creates: /srv/airflow/DB_INITIALIZED
    - env:
        - AIRFLOW_HOME: /srv/airflow
        - AIRFLOW_CONFIG: /srv/airflow/airflow.cfg
    - require:
      - create airflow db user
      - create airflow db
      - set privileges for airflow db
      - create airflow virtualenv
      - airflow config file

run airflow initdb only once:
  file.managed:
    - name: /srv/airflow/DB_INITIALIZED
    - contents: ""
    - user: airflow
    - group: airflow
    - require:
      - init airflow db

airflow webserver systemd service:
  file.managed:
    - name: /etc/systemd/system/airflow-webserver.service
    - source:
      - salt://templates/airflow-webserver.service

run airflow webserver service:
  service.running:
    - name: airflow-webserver.service
    - enable: True
    - no_block: True
    - require:
      - airflow webserver systemd service
      - init airflow db
    - watch:
      - file: airflow config file

airflow scheduler systemd service:
  file.managed:
    - name: /etc/systemd/system/airflow-scheduler.service
    - source:
      - salt://templates/airflow-scheduler.service

run airflow scheduler service:
  service.running:
    - name: airflow-scheduler.service
    - enable: True
    - no_block: True
    - require:
      - airflow scheduler systemd service
      - init airflow db
    - watch:
      - file: airflow config file
