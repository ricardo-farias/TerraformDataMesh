# Deploy to ECR and Run CitiBike Jar on Airflow

1. Open `main.tf` and make sure that everything but the EMR module is *uncommented*.

2. `terraform plan`
3. `terraform apply`
4. Once that is complete, copy the `ecr_url` from the outputs up to `/airflow`.

```
# example
569550148282.dkr.ecr.us-east-2.amazonaws.com
```

5. In `docker-compose.yml` replace the image value for the worker, webserver, scheduler and flower images with your ecr_url and append `/airflow:latest`

```
# example
image: 569550148282.dkr.ecr.us-east-2.amazonaws.com/airflow:latest
```

6. Make sure that you've updated any s3 bucket names referenced in `citi-bike-pipeline.py` and `EmrClusterController.py` are updated to match your unique bucket names.

7. Set up the following 5 CloudWatch logs on your AWS Console by going to CloudWatch > Log groups and `create log group` and adding them one at a time.

```
/aws-glue/crawler
/ecs/Redis
/ecs/Scheduler
/ecs/Webserver
/ecs/Worker
```

8. `cd airflow`
9. `chmod +x /scripts/deploy-to-ecr.sh`
10. `./scripts/deploy-to-ecr.sh <your_ecr_url>`

```
# example
./scripts/deploy-to-ecr.sh  569550148282.dkr.ecr.us-east-2.amazonaws.com
```

11. Once the script is complete, go to ECS on your AWS console. Click `Airflow` > `Airflow-Webserver` > `Tasks`. Open up the Task by clicking on it. Copy the Public IP address and open it up in a new browser window by appending `:8080` to it.  This opens the Airflow UI.

```
# example
18.216.128.196:8080
```

12. I needed to go to Admin > Variables and fill in my `aws_access_key_id` and `aws_secret_access_key`. (Same as `credentials` file for `profile sparkapp`).
13. Make sure the CitiBike jar and credentials file are in your `emr-configuratoin-scripts` s3 bucket, and that the datafiles are in the `citi-bike-data bucket`.
14. Navigate back to the `Dags` tab. You should now be able to click on the `citi-bike-pipeline` and `Trigger Dag` to run the CitiBike jar on an EMR cluster. Wooo!!