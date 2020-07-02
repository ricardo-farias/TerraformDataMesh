from airflow.contrib.operators.ssh_operator import SSHOperator
from airflow.models import DAG
from airflow.operators.bash_operator import BashOperator
from airflow.utils.dates import days_ago


args = {
    'owner': 'Airflow',
    'start_date': days_ago(2)
}

dag = DAG(
    'SparkSubmit',
    default_args=args,
    description='A simple tutorial DAG',
    schedule_interval=None,
)

submit_job = BashOperator(
    task_id="runafterloop",
    bash_command="echo 1",
    dag=dag
)

submit_job1 = SSHOperator(
    task_id="emrsparksubmit",
    dag=dag
)


submit_job