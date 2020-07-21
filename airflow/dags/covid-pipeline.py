from airflow import DAG
from airflow.operators.python_operator import PythonOperator
from airflow.utils.dates import days_ago
from controllers.EmrClusterController import EmrClusterController

args = {
    'owner': 'Airflow',
    'start_date': days_ago(2)
}


def create_cluster(**kwargs):
    cluster_id = EmrClusterController.create_cluster_job_execution("Covid Cluster", "emr-5.30.0")
    return cluster_id


def wait_for_cluster(**kwargs):
    ti = kwargs['ti']
    cluster_id = ti.xcom_pull(task_ids='create_cluster')
    EmrClusterController.wait_for_cluster_creation(cluster_id)


def get_credentials(**kwargs):
    ti = kwargs['ti']
    cluster_id = ti.xcom_pull(task_ids='create_cluster')
    step_id = EmrClusterController.add_job_step(cluster_id, "Get-Credentials", "command-runner.jar",
                           ["aws", "s3", "cp", "s3://emr-configuration-scripts/credentials", "/home/hadoop/.aws/"])
    EmrClusterController.wait_for_step_completion(cluster_id, step_id)
    status = EmrClusterController.get_step_status(cluster_id, step_id)
    if status == "FAILED":
        print("GET CREDENTIALS FROM S3 FAILED")
        raise RuntimeError("Get Credentials Failed During Execution: Reason documented in logs probably...?")
    elif status == "COMPLETED":
        print("GET CREDENTIALS FROM S3 COMPLETED SUCCESSFULLY")


def get_jar(**kwargs):
    ti = kwargs['ti']
    cluster_id = ti.xcom_pull(task_ids='create_cluster')
    step_id = EmrClusterController.add_job_step(cluster_id, "Get-Jars", "command-runner.jar",
                           ['aws', 's3', 'cp', 's3://emr-configuration-scripts/SparkPractice-assembly-0.1.jar',
                            "/home/hadoop/"])
    EmrClusterController.wait_for_step_completion(cluster_id, step_id)
    status = EmrClusterController.get_step_status(cluster_id, step_id)
    if status == "FAILED":
        print("GET JAR FROM S3 FAILED")
        raise RuntimeError("Get Jar Failed During Execution: Reason documented in logs probably...?")
    elif status == "COMPLETED":
        print("GET JAR FROM S3 COMPLETED SUCCESSFULLY")


def spark_submit(**kwargs):
    ti = kwargs['ti']
    cluster_id = ti.xcom_pull(task_ids='create_cluster')
    step_id = EmrClusterController.add_job_step(cluster_id, "Spark-Submit", "command-runner.jar",
                           ['spark-submit', '--class', 'com.ricardo.farias.App',
                            "/home/hadoop/SparkPractice-assembly-0.1.jar"])
    EmrClusterController.wait_for_step_completion(cluster_id, step_id)
    status = EmrClusterController.get_step_status(cluster_id, step_id)
    if status == "FAILED":
        print("SPARK SUBMIT JOB FAILED")
        raise RuntimeError("Spark Job Failed During Execution: Reason documented in logs probably...?")
    elif status == "COMPLETED":
        print("SPARK SUBMIT JOB COMPLETED SUCCESSFULLY")


def terminate_cluster(**kwargs):
    ti = kwargs['ti']
    cluster_id = ti.xcom_pull(task_ids='create_cluster')
    EmrClusterController.terminate_cluster(cluster_id)


dag = DAG(
    'covid-pipeline',
    default_args=args,
    description='Spark Submit job to EMR',
    schedule_interval=None,
)

create_cluster_task = PythonOperator(
    task_id="create_cluster",
    python_callable=create_cluster,
    provide_context=True,
    dag=dag
)

wait_for_cluster_task = PythonOperator(
    task_id="wait_for_cluster",
    python_callable=wait_for_cluster,
    provide_context=True,
    dag=dag
)

get_credentials_task = PythonOperator(
    task_id="get_credentials",
    python_callable=get_credentials,
    provide_context=True,
    dag=dag
)

get_jar_task = PythonOperator(
    task_id="get_jar",
    python_callable=get_jar,
    provide_context=True,
    dag=dag
)

spark_submit_task = PythonOperator(
    task_id="spark_submit",
    python_callable=spark_submit,
    provide_context=True,
    dag=dag
)

terminate_cluster_task = PythonOperator(
    task_id="terminate_cluster",
    python_callable=terminate_cluster,
    provide_context=True,
    trigger_rule='all_done',
    dag=dag
)

create_cluster_task >> \
    wait_for_cluster_task >> \
    get_credentials_task >> \
    get_jar_task >> \
    spark_submit_task >> \
    terminate_cluster_task
