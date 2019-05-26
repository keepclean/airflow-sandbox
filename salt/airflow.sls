add airflow user:
  user.present:
    - name: airflow
    - home: /srv/airflow
    - shell: /bin/bash
    - optional_groups:
      - sudo

/srv/airflow:
  file.directory:
    - user: airflow
    - group: airflow

create airflow virtualenv:
  virtualenv.managed:
    - name: /srv/airflow
    - python: python3
    - user: airflow
    - pip_pkgs:
      - apache-airflow
      - 'apache-airflow[postgres]'
      - psycopg2
