import sys, json, os
from controllers.EmrClusterController import EmrClusterController

def create_EMR_cluster(cluster_name, emr_version):
    cluster_id = EmrClusterController.create_cluster_job_execution(cluster_name, emr_version)
    print("Waiting for Cluster: ", cluster_id)
    xcom_return = {"clusterId": cluster_id}
    
    with open ("/airflow/xcom/return.json", "w") as file:
        json.dump(xcom_return, file)
    
    return EmrClusterController.wait_for_cluster_creation(cluster_id)

# TODO: Refactor to take in S3 Bucket Path instead of data_product 
def configure_job(cluster_id, data_product):
    step_get_credentials = EmrClusterController.add_job_step(cluster_id, "Get-Credentials", "command-runner.jar",
                                                ["aws", "s3", "cp", "s3://art-emr-configuration-scripts/credentials",
                                                 "/home/hadoop/.aws/"])
    EmrClusterController.wait_for_step_completion(cluster_id, step_get_credentials)
    status = EmrClusterController.get_step_status(cluster_id, step_get_credentials)
    if status == "FAILED":
        print("GET CREDENTIALS FROM S3 FAILED")
        raise RuntimeError("Get Credentials Failed During Execution: Reason documented in logs probably...?")
    elif status == "COMPLETED":
        print("GET CREDENTIALS FROM S3 COMPLETED SUCCESSFULLY")

    if data_product == 'citi_bike':
        s3_jar_path = 's3://art-emr-configuration-scripts/CitiBikeDataProduct-assembly-0.1.jar'
    elif data_product == 'covid':
        s3_jar_path = 's3://art-emr-configuration-scripts/SparkPractice-assembly-0.1.jar'
    else:
        raise RuntimeError("Invalid data_product Option")
        
    step_id = EmrClusterController.add_job_step(cluster_id, "Get-Jars", "command-runner.jar",
                                            ['aws', 's3', 'cp', s3_jar_path,"/home/hadoop/"])

    EmrClusterController.wait_for_step_completion(cluster_id, step_id)
    status = EmrClusterController.get_step_status(cluster_id, step_id)
    if status == "FAILED":
        print("GET JAR FROM S3 FAILED")
        raise RuntimeError("Get Jar Failed During Execution: Reason documented in logs probably...?")
    elif status == "COMPLETED":
        print("GET JAR FROM S3 COMPLETED SUCCESSFULLY")    

# TODO: Refactor to take in Bucket Path instead of data_product 
def spark_submit(cluster_id, data_product):
    if data_product == 'citi_bike':
        jar_path = '/home/hadoop/CitiBikeDataProduct-assembly-0.1.jar'
    elif data_product == 'covid':
        jar_path = '/home/hadoop/SparkPractice-assembly-0.1.jar'
    else:
        raise RuntimeError("Invalid data_product Option")

    step_spark_submit = EmrClusterController.add_job_step(cluster_id, "Spark-Submit", "command-runner.jar",
                                                ['spark-submit', '--class', 'com.ricardo.farias.App',jar_path])
    EmrClusterController.wait_for_step_completion(cluster_id, step_spark_submit)
    status = EmrClusterController.get_step_status(cluster_id, step_spark_submit)
    if status == "FAILED":
        print("SPARK SUBMIT JOB FAILED")
        raise RuntimeError("Spark Job Failed During Execution: Reason documented in logs probably...?")
    elif status == "COMPLETED":
        print("SPARK SUBMIT JOB COMPLETED SUCCESSFULLY")

def terminate_cluster(cluster_id):
    EmrClusterController.terminate_cluster(cluster_id)

if __name__ == "__main__":
    if len(sys.argv) < 2:
        raise SyntaxError("Insufficient arguments.")

    if os.environ["DATA_PRODUCT"]=='citi_bike':
        data_product = "citi_bike"
    elif os.environ["DATA_PRODUCT"]=='covid':
        data_product = "covid"
    else:
        raise RuntimeError("Invalid ENV Variable - Please set appropriate DATA_PRODUCT ENV")

    option = sys.argv[1]

    if option == "create_cluster":
        print ("Create EMR Cluster")
        cluster_id = create_EMR_cluster(data_product + " Cluster", "emr-5.30.0")
    
    elif option == "configure_job":
        print ("Configuring Job")
        configure_job(sys.argv[2], data_product)
    
    elif option == "submit_job":
        print("Submitting Spark Job")
        spark_submit(sys.argv[2], data_product)

    elif option == "terminate_cluster":
        print("Terminating EMR Cluster")
        terminate_cluster(sys.argv[2])
    else:
        print ("Invalid Options")
        exit(-1)
