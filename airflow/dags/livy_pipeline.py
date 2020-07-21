from airflow import DAG
from airflow.operators.python_operator import PythonOperator
from airflow.utils.dates import days_ago
from controllers.EmrClusterController import EmrClusterController

args = {
    'owner': 'Airflow',
    'start_date': days_ago(2)
}


def create_emr_cluster(**kwargs):
    cluster_id = EmrClusterController.create_cluster_job_execution("Livy Cluster", "emr-5.30.0")
    return cluster_id


def wait_for_cluster(**kwargs):
    ti = kwargs['ti']
    cluster_id = ti.xcom_pull(task_ids='create_cluster')
    EmrClusterController.wait_for_cluster_creation(cluster_id)


def create_livy_session(**kwargs):
    ti = kwargs['ti']
    cluster_id = ti.xcom_pull(task_ids='create_cluster')
    master_dns = EmrClusterController.get_cluster_dns(cluster_id)
    print(f"\n\n MASTER DNS: {master_dns}")
    response_headers = EmrClusterController.create_spark_session(master_dns)
    print(f"Create Spark Session: {response_headers}")
    session_url = EmrClusterController.wait_for_idle_session(master_dns, response_headers)
    spark_response = EmrClusterController.submit_statement(session_url, "./dags/spark/RddCreation.scala")
    print(f"Spark Command Response: {spark_response}")
    EmrClusterController.track_statement_progress(master_dns, spark_response.headers)
    EmrClusterController.kill_spark_session(session_url)


def terminate_cluster(**kwargs):
    ti = kwargs['ti']
    cluster_id = ti.xcom_pull(task_ids='create_cluster')
    EmrClusterController.terminate_cluster(cluster_id)


dag = DAG(
    'livy-pipeline',
    default_args=args,
    description='Spark Submit job to EMR',
    schedule_interval=None,
)

create_cluster_task = PythonOperator(
    task_id="create_cluster",
    python_callable=create_emr_cluster,
    provide_context=True,
    dag=dag
)

wait_for_cluster_task = PythonOperator(
    task_id="wait_for_cluster",
    python_callable=wait_for_cluster,
    provide_context=True,
    dag=dag
)

create_livy_session_task = PythonOperator(
    task_id='spark_command',
    python_callable=create_livy_session,
    provide_context=True,
    dag=dag
)

terminate_cluster_task = PythonOperator(
    task_id='terminate_cluster',
    python_callable=terminate_cluster,
    provide_context=True,
    trigger_rule='all_done',
    dag=dag
)

create_cluster_task >> \
    wait_for_cluster_task >> \
    create_livy_session_task >> \
    terminate_cluster_task
