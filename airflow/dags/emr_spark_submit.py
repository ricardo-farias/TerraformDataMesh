from airflow.contrib.operators.ssh_operator import SSHOperator
from airflow.models import DAG
from airflow.operators.bash_operator import BashOperator
from airflow.operators.python_operator import PythonOperator
from airflow.utils.dates import days_ago
import paramiko


def connect(ds, **kwargs):
    key = paramiko.RSAKey.from_private_key_file("/usr/local/airflow/.ssh/EMR-key-pair.pem")
    conn = paramiko.SSHClient()
    conn.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    print("connecting")
    conn.connect(hostname="ec2-3-12-150-143.us-east-2.compute.amazonaws.com", username="hadoop", pkey=key)
    print("connected")
    commands = ["hostname", "w"]
    for command in commands:
        print("Executing {}".format(command))
    stdin, stdout, stderr = conn.exec_command(command)
    print(stdout.read())
    print("Errors")
    print(stderr.read())
    conn.close()


args = {
    'owner': 'Airflow',
    'start_date': days_ago(2)
}

dag = DAG(
    'SparkSubmit',
    default_args=args,
    description='Spark Submit job to EMR',
    schedule_interval=None,
)


py_operator = PythonOperator(
    task_id="read-unreadable",
    python_callable=connect,
    provide_context=True,
    dag=dag
)

bash = BashOperator(
    task_id="whoisthis",
    bash_command="whoami",
    dag=dag
)

submit_job1 = SSHOperator(
    task_id="Submit",
    ssh_conn_id="EMR_CONNECTION",
    app_name="Data Mesh",
    command="spark-submit --class com.ricardo.farias.App SparkPractice-assembly-0.1.jar",
    provide_context=True,
    dag=dag
)


bash >> py_operator >> submit_job1
