from airflow.models import DAG
from airflow.operators.bash_operator import BashOperator
from airflow.utils.dates import days_ago


args = {
    'owner': 'Airflow',
    'start_date': days_ago(2)
}

dag = DAG(
    'AllEnvVariables',
    default_args=args,
    description='Spark Submit job to EMR',
    schedule_interval=None,
)

tas1 = BashOperator(
    task_id="env-print",
    bash_command="printenv",
    dag=dag
)


tas1