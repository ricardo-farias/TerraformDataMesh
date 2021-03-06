import sys, json, os
from controllers.EmrClusterController import EmrClusterController


def create_EMR_cluster(cluster_name, emr_version, subnet_ids):
    cluster_id = EmrClusterController.create_cluster_job_execution(cluster_name, emr_version, subnet_ids)
    print("Waiting for Cluster: ", cluster_id)
    xcom_return = {"clusterId": cluster_id}

    with open("/airflow/xcom/return.json", "w") as file:
        json.dump(xcom_return, file)

    return EmrClusterController.wait_for_cluster_creation(cluster_id)


# TODO: Refactor to take in S3 Bucket Path instead of data_product 
def configure_job(cluster_id, s3_jar_path):
    step_id = EmrClusterController.add_job_step(cluster_id, "Get-Jars", "command-runner.jar",
                                                ['aws', 's3', 'cp', s3_jar_path, "/home/hadoop/"])
    EmrClusterController.wait_for_step_completion(cluster_id, step_id)
    status = EmrClusterController.get_step_status(cluster_id, step_id)
    if status == "FAILED":
        print("GET JAR FROM S3 FAILED")
        raise RuntimeError("Get Jar Failed During Execution: Reason documented in logs probably...?")
    elif status == "COMPLETED":
        print("GET JAR FROM S3 COMPLETED SUCCESSFULLY")

    # TODO: Refactor to take in Bucket Path instead of data_product


def spark_submit(cluster_id, jar_path):
    step_spark_submit = EmrClusterController.add_job_step(cluster_id, "Spark-Submit", "command-runner.jar",
                                                          ['spark-submit', '--class', 'com.ricardo.farias.App',
                                                           jar_path])
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

    if os.environ["DATA_PRODUCT"] == 'citi_bike':
        data_product = "citi_bike"
        s3_jar_path = 's3://<emr_jar_bucket>/CitiBikeDataProduct-assembly-0.1.jar'  # TODO Change bucket name
        jar_path = '/home/hadoop/CitiBikeDataProduct-assembly-0.1.jar'

    elif os.environ["DATA_PRODUCT"] == 'covid':
        data_product = "covid"
        s3_jar_path = 's3://<emr_jar_bucket>/CovidDataProduct-assembly-0.1.jar'  # TODO Change bucket name
        jar_path = '/home/hadoop/CovidDataProduct-assembly-0.1.jar'
    else:
        raise RuntimeError("Invalid ENV Variable - Please set appropriate DATA_PRODUCT ENV")

    subnet_id = "<public_subnet_id>"  # TODO Add subnet id
    selection = sys.argv[1]

    if selection == 'create_cluster':
        create_EMR_cluster(data_product + " Cluster", "emr-5.30.0", subnet_id)
    elif selection == 'configure_job':
        configure_job(sys.argv[2], s3_jar_path)
    elif selection == 'submit_job':
        spark_submit(sys.argv[2], jar_path)
    elif selection == 'terminate_cluster':
        terminate_cluster(sys.argv[2])
    else:
        print("Invalid Options")
        exit(-1)
