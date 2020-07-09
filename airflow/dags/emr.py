from airflow_variables import *
import boto3
from airflow.models import Variable


class EMR:

    connection = boto3.client(
        'emr',
        region_name='us-east-2',
        aws_access_key_id=Variable.get("aws_access_key_id"),
        aws_secret_access_key=Variable.get("aws_secret_access_key"),
    )

    @staticmethod
    def create_cluster_job_execution(name, release,
                                     master_node_type="m5.xlarge",
                                     slave_node_type="m5.xlarge",
                                     master_instance_count=1,
                                     slave_instance_count=1):
        response = EMR.connection.run_job_flow(
            Name=name,
            ReleaseLabel=release,
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
                        'InstanceType': master_node_type,
                        'InstanceCount': master_instance_count,
                    },
                    {
                        'Name': "Slave nodes",
                        'Market': 'ON_DEMAND',
                        'InstanceRole': 'CORE',
                        'InstanceType': slave_node_type,
                        'InstanceCount': slave_instance_count,
                    }
                ],
                'Ec2KeyName': 'EMR-key-pair',
                'EmrManagedMasterSecurityGroup': "sg-022da502cb4aa1722",
                'EmrManagedSlaveSecurityGroup': "sg-00921d5d61b9a7b11",
                'KeepJobFlowAliveWhenNoSteps': True,
                'TerminationProtected': False,
                'Ec2SubnetId': 'subnet-0d67fc1e75522aa13',
            },
            VisibleToAllUsers=True,
            ServiceRole='iam_emr_service_role',
            JobFlowRole='emr-instance-profile',
        )

        print('cluster created with the step...', response['JobFlowId'])
        return response["JobFlowId"]

    @staticmethod
    def add_job_step(cluster_id, name, jar, args, main_class="", action="CONTINUE"):
        response = EMR.connection.add_job_flow_steps(
            JobFlowId=cluster_id,
            Steps=[
                {
                    'Name': name,
                    'ActionOnFailure': action,
                    'HadoopJarStep': {
                        'Jar': jar,
                        'MainClass': main_class,
                        'Args': args
                    }
                },
            ]
        )
        print(f"Add Job Response: {response}")
        return response['StepIds'][0]

    @staticmethod
    def list_job_steps(cluster_id):
        response = EMR.connection.list_steps(
            ClusterId=cluster_id,
            StepStates=['PENDING', 'CANCEL_PENDING', 'RUNNING', 'COMPLETED', 'CANCELLED', 'FAILED', 'INTERRUPTED']
        )
        for cluster in response['Clusters']:
            print(cluster['Name'])
            print(cluster['Id'])

    @staticmethod
    def get_step_status(cluster_id, step_id):
        response = EMR.connection.describe_step(ClusterId=cluster_id, StepId=step_id)
        return response['Step']['Status']

    @staticmethod
    def wait_for_cluster_creation(cluster_id):
        EMR.connection.get_waiter('cluster_running').wait(ClusterId=cluster_id)

    @staticmethod
    def wait_for_step_completion(cluster_id, step_id):
        EMR.connection.get_waiter('step_complete').wait(ClusterId=cluster_id, StepId=step_id)

    @staticmethod
    def terminate_cluster(cluster_id):
        EMR.connection.terminate_job_flows(JobFlowIds=[cluster_id])
