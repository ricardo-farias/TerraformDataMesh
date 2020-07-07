import boto3
from airflow import DAG
from airflow.models import Variable
from airflow.operators.python_operator import PythonOperator
from airflow.utils.dates import days_ago

connection = boto3.client(
    'emr',
    region_name='us-east-2',
    aws_access_key_id=Variable.get("aws_access_key_id"),
    aws_secret_access_key=Variable.get("aws_secret_access_key"),
)


def create_cluster_job_execution(ds, **kwargs):
    clusterid = connection.run_job_flow(
        Name='Data Mesh Cluster',
        ReleaseLabel='emr-5.30.0',
        LogUri='s3://emr-data-mesh-logging-bucket',
        Applications=[
            {
                'Name': 'Spark'
            },
        ],
        Instances={
            'InstanceGroups': [
                {
                    'Name': "Master nodes",
                    'Market': 'ON_DEMAND',
                    'InstanceRole': 'MASTER',
                    'InstanceType': 'm5.xlarge',
                    'InstanceCount': 1,
                },
                {
                    'Name': "Slave nodes",
                    'Market': 'ON_DEMAND',
                    'InstanceRole': 'CORE',
                    'InstanceType': 'm5.xlarge',
                    'InstanceCount': 1,
                }
            ],
            'Ec2KeyName': 'EMR-key-pair',
            'EmrManagedMasterSecurityGroup': "sg-0980c1d5ea0ca94b4",
            'EmrManagedSlaveSecurityGroup': "sg-059482066120cd855",
            'KeepJobFlowAliveWhenNoSteps': False,
            'TerminationProtected': False,
            'Ec2SubnetId': 'subnet-05f42e2723bcdeda1',
        },
        Steps=[
            {
                'Name': 'file-copy-step',
                'ActionOnFailure': 'CONTINUE',
                'HadoopJarStep': {
                    'Jar': 'command-runner.jar',
                    'Args': ['aws', 's3', 'cp', 's3://emr-configuration-scripts/SparkPractice-assembly-0.1.jar',
                             "/home/hadoop/"]
                }
            },
            {
                "Name": 'copy-credentials',
                'ActionOnFailure': 'CONTINUE',
                'HadoopJarStep': {
                    'Jar': "command-runner.jar",
                    'Args': ["aws", "s3", "cp", "s3://emr-configuration-scripts/credentials", "/home/hadoop/.aws/"],
                }
            },
            {
                'Name': 'spark-submit',
                'ActionOnFailure': 'CONTINUE',
                'HadoopJarStep': {
                    'Jar': 'command-runner.jar',
                    'Args': ['spark-submit', '--class', 'com.ricardo.farias.App',
                             '/home/hadoop/SparkPractice-assembly-0.1.jar']
                }
            }
        ],
        VisibleToAllUsers=True,
        ServiceRole='iam_emr_service_role',
        JobFlowRole='emr-instance-profile',
    )

    print('cluster created with the step...', clusterid['JobFlowId'])
    return clusterid["JobFlowId"]


args = {
    'owner': 'Airflow',
    'start_date': days_ago(2)
}

dag = DAG(
    'EMR_Job',
    default_args=args,
    description='Spark Submit job to EMR',
    schedule_interval=None,
)

emr_job = PythonOperator(
    task_id="emr_job",
    python_callable=create_cluster_job_execution,
    provide_context=True,
    dag=dag
)

emr_job
