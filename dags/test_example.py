# coding: utf-8

import airflow
from airflow.models import DAG
from airflow.operators.python_operator import PythonOperator
import time

args = {
    'owner': 'airflow',
    'start_date': airflow.utils.dates.days_ago(1),
}

dag = DAG(
    dag_id='test_example_python_operator',
    default_args=args,
    schedule_interval=None,
)


def print_context(ds, **kwargs):
    print(kwargs)
    print(ds)
    return 'this line should be in the logs'


run_this = PythonOperator(
    task_id='print_the_context',
    provide_context=True,
    python_callable=print_context,
    dag=dag,
)


def sleep(t):
    time.sleep(t)


for i in range(5):
    task = PythonOperator(
        task_id='sleep_for_{}'.format(i),
        python_callable=sleep,
        op_kwargs={'t': float(i) / 10},
        dag=dag,
    )

    run_this >> task
