import os
import boto3, json, time, logging, requests

class EmrClusterController:

    connection = boto3.client(
        'emr',
        region_name='us-east-2',
        aws_access_key_id=os.environ["AWS_ACCESS_KEY_ID"],
        aws_secret_access_key=os.environ["AWS_SECRET_ACCESS_KEY"]
    )

    @staticmethod
    def create_cluster_job_execution(name, release,
                                     subnet_id,
                                     master_instance_type="m4.large",
                                     core_instance_type="m4.large",
                                     master_instance_count=1,
                                     core_instance_count=1):
        public_subnet = subnet_id
        response = EmrClusterController.connection.run_job_flow(
            Name=name,
            ReleaseLabel=release,
            LogUri='s3://data-mesh-poc-bernardm-emr-data-mesh-logging-bucket',
            Applications=[
                {'Name': 'hadoop'},
                { 'Name': 'spark'},
                {'Name': 'hive'},
                {'Name': 'livy'},
                {'Name': 'zeppelin'}
            ],
            Instances={
                'InstanceGroups': [
                    {
                        'Market': 'ON_DEMAND',
                        'InstanceRole': 'MASTER',
                        'InstanceType': master_instance_type,
                        'InstanceCount': master_instance_count,
                    },
                    {
                        'Market': 'ON_DEMAND',
                        'InstanceRole': 'CORE',
                        'InstanceType': core_instance_type,
                        'InstanceCount': core_instance_count,
                    }
                ],
                'Ec2KeyName': 'EMR-key-pair',
                'KeepJobFlowAliveWhenNoSteps': True,
                'TerminationProtected': False,
                'Ec2SubnetId': public_subnet,
            },
            VisibleToAllUsers=True,
            ServiceRole='EMR_DefaultRole',
            JobFlowRole='EMR_EC2_DefaultRole'
        )

        print('cluster created with the step...', response['JobFlowId'])
        return response["JobFlowId"]

    @staticmethod
    def add_job_step(cluster_id, name, jar, args, main_class="", action="CONTINUE"):
        response = EmrClusterController.connection.add_job_flow_steps(
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
        response = EmrClusterController.connection.list_steps(
            ClusterId=cluster_id,
            StepStates=['PENDING', 'CANCEL_PENDING', 'RUNNING', 'COMPLETED', 'CANCELLED', 'FAILED', 'INTERRUPTED']
        )
        for cluster in response['Clusters']:
            print(cluster['Name'])
            print(cluster['Id'])

    @staticmethod
    def get_step_status(cluster_id, step_id):
        response = EmrClusterController.connection.describe_step(ClusterId=cluster_id, StepId=step_id)
        return response['Step']['Status']

    @staticmethod
    def get_cluster_dns(cluster_id):
        response = EmrClusterController.connection.describe_cluster(ClusterId=cluster_id)
        return response['Cluster']['MasterPublicDnsName']

    @staticmethod
    def get_public_ip(cluster_id):
        instances = EmrClusterController.connection.list_instances(ClusterId=cluster_id, InstanceGroupTypes=['MASTER'])
        return instances['Instances'][0]['PublicIpAddress']

    @staticmethod
    def wait_for_cluster_creation(cluster_id):
        EmrClusterController.connection.get_waiter('cluster_running').wait(ClusterId=cluster_id)

    @staticmethod
    def wait_for_step_completion(cluster_id, step_id):
        EmrClusterController.connection.get_waiter('step_complete').wait(ClusterId=cluster_id, StepId=step_id)

    @staticmethod
    def terminate_cluster(cluster_id):
        EmrClusterController.connection.terminate_job_flows(JobFlowIds=[cluster_id])

    @staticmethod
    def create_spark_session(master_dns, kind='spark'):
        host = "http://" + master_dns + ":8998"
        conf = {"hive.metastore.client.factory.class": "com.amazonaws.glue.catalog.metastore.AWSGlueDataCatalogHiveClientFactory"}
        data = {"kind": kind, "conf": conf}
        headers = {"Content-Type": "application/json"}
        response = requests.post(host + "/sessions", data=json.dumps(data), headers=headers)
        print(f"\n\nCREATE SPARK SESSION RESPONSE STATUS CODE: {response.status_code}")
        logging.info(response.json())
        print("\n\nCREATED LIVY SPARK SESSION SUCCESSFULLY")
        return response.headers

    @staticmethod
    def wait_for_idle_session(master_dns, response_headers):
        status = ""
        host = "http://" + master_dns + ":8998"
        session_url = host + response_headers['location']
        print(f"\n\nWAIT FOR IDLE SESSION: Session URL: {session_url}")
        while status != "idle":
            time.sleep(3)
            status_response = requests.get(session_url, headers={"Content-Type": "application/json"})
            status = status_response.json()['state']
            logging.info('Session status: ' + status)
        print("\n\nLIVY SPARK SESSION IS IDLE")
        return session_url

    @staticmethod
    def submit_statement(session_url, statement_path):
        statements_url = session_url + "/statements"
        with open(statement_path, 'r') as f:
            code = f.read()
        data = {"code": code}
        response = requests.post(statements_url, data=json.dumps(data), headers={"Content-Type": "application/json"})
        logging.info(response.json())
        print("\n\nSUBMITTED LIVY STATEMENT SUCCESSFULLY")
        return response

    @staticmethod
    def track_statement_progress(master_dns, response_headers):
        statement_status = ""
        host = "http://" + master_dns + ":8998"
        session_url = host + response_headers['location'].split('/statements', 1)[0]
        # Poll the status of the submitted scala code
        while statement_status != "available":
            statement_url = host + response_headers['location']
            statement_response = requests.get(statement_url, headers={"Content-Type": "application/json"})
            statement_status = statement_response.json()['state']
            logging.info('Statement status: ' + statement_status)
            lines = requests.get(session_url + '/log', headers={'Content-Type': 'application/json'}).json()['log']
            for line in lines:
                logging.info(line)

            if 'progress' in statement_response.json():
                logging.info('Progress: ' + str(statement_response.json()['progress']))
            time.sleep(10)
        final_statement_status = statement_response.json()['output']['status']
        if final_statement_status == 'error':
            logging.info('Statement exception: ' + statement_response.json()['output']['evalue'])
            for trace in statement_response.json()['output']['traceback']:
                logging.info(trace)
            raise ValueError('Final Statement Status: ' + final_statement_status)
        print(statement_response.json())
        logging.info('Final Statement Status: ' + final_statement_status)

    @staticmethod
    def kill_spark_session(session_url):
        requests.delete(session_url, headers={"Content-Type": "application/json"})
        print("\n\nLIVY SESSION WAS DELETED SUCCESSFULLY")

    @staticmethod
    def create_livy_batch(master_dns, path, class_name):
        data = {"file": path, "className": class_name}
        host = "http://" + master_dns + ":8998"
        headers = {"Content-Type": "application/json"}
        response = requests.post(host + "/batches", data=json.dumps(data), headers=headers)
        print(f"\n\nCREATE SPARK SESSION RESPONSE STATUS CODE: {response.status_code}")
        logging.info(response.json())
        print("\n\nCREATED LIVY SPARK SESSION SUCCESSFULLY")
        return response.json()["id"]

    @staticmethod
    def track_livy_batch_job(master_dns, batch_id):
        statement_status = ""
        host = "http://" + master_dns + ":8998"
        session_url = host + "/batches/" + str(batch_id)
        # Poll the status of the submitted scala code
        while statement_status != "available":
            statement_url = host + "/state"
            statement_response = requests.get(statement_url, headers={"Content-Type": "application/json"})
            statement_status = statement_response.json()['state']
            logging.info('Statement status: ' + statement_status)
            lines = requests.get(session_url + '/log', headers={'Content-Type': 'application/json'}).json()['log']
            for line in lines:
                logging.info(line)

            if 'progress' in statement_response.json():
                logging.info('Progress: ' + str(statement_response.json()['progress']))
            time.sleep(10)
        final_statement_status = statement_response.json()['output']['status']
        if final_statement_status == 'error':
            logging.info('Statement exception: ' + statement_response.json()['output']['evalue'])
            for trace in statement_response.json()['output']['traceback']:
                logging.info(trace)
            raise ValueError('Final Statement Status: ' + final_statement_status)
        print(statement_response.json())
        logging.info('Final Statement Status: ' + final_statement_status)

    @staticmethod
    def terminate_batch_job(master_dns, batch_id):
        requests.delete(f"http://{master_dns}:8998/batches/{batch_id}", headers={"Content-Type": "application/json"})
        print("\n\nLIVY SESSION WAS DELETED SUCCESSFULLY")
