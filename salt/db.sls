create airflow db user:
  postgres_user.present:
    - name: airflow
    - password: airflow
    - user: postgres

create airflow db:
  postgres_database.present:
    - name: airflow
    - owner: airflow
    - user: postgres

set privileges for airflow db:
  postgres_privileges.present:
    - name: airflow
    - object_name: 'ALL'
    - object_type: table
    - privileges:
      - ALL
    - user: postgres
