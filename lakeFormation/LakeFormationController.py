import boto3
import json, sys


class LakeFormationController:

    def __init__(self, params):
        self.session = boto3.Session(profile_name='terraform')

        self.client = self.session.client(
            'lakeformation',
            region_name='us-east-2'
        )

        self.db_name = params["db_name"]
        self.account_id = params["account_id"]
        self.lf_admin = f"arn:aws:iam::{self.account_id}:user/{params['lf_admin']}"
        self.emr_instance_profile = f"arn:aws:iam::{self.account_id}:role/EMR_EC2_DefaultRole"
        self.s3_domain_locations = params["s3_domain_locations"]

    def create_lake_formation(self):
        self.overwrite_administrators(self.lf_admin)
        self.grant_permissions(self.lf_admin, 'Database', ["ALL"], ["ALL"])
        self.grant_permissions(self.lf_admin, 'Table', ["ALL"], ["ALL"])
        self.grant_permissions(self.emr_instance_profile, 'Database', ["ALL"])
        self.grant_permissions(self.emr_instance_profile, 'Table', ["ALL"])
        self.register_all_resources(self.s3_domain_locations)

    def overwrite_administrators(self, admin_arn):
        response = self.client.put_data_lake_settings(
            DataLakeSettings={
                'DataLakeAdmins': [
                    {
                        'DataLakePrincipalIdentifier': admin_arn
                    },
                ]
            }
        )
        if response["ResponseMetadata"]["HTTPStatusCode"] is 200:
            print(f"AWS Lake Formation Administrator set to {admin_arn}")
        else:
            print(response)

    def grant_permissions(self, principal_arn, structure, permission_list=[], grant_permission_list=[]):
        # currently gives the principal access to all tables in specified db (if structure is table)
        resource = None

        if structure == 'Table':
            resource = {
                'Table': {
                    'DatabaseName': self.db_name,
                    'TableWildcard': {}
                }
            }

        elif structure == 'Database':
            resource = {
                'Database': {
                    'Name': self.db_name
                }
            }

        response = self.client.grant_permissions(
            Principal={
                'DataLakePrincipalIdentifier': principal_arn
            },
            Resource=resource,
            Permissions=permission_list,
            PermissionsWithGrantOption=grant_permission_list
        )

        if response['ResponseMetadata']['HTTPStatusCode'] is 200:
            print(f"Permissions granted to {principal_arn}")
        else:
            print(resource, response)

    def register_all_resources(self, resource_list):
        for resource in resource_list:
            try:
                self.register_resource_location(resource)
            except self.client.exceptions.AlreadyExistsException:
                print(f"Resource {resource} already exists")

    def register_resource_location(self, bucket_arn):
        response = self.client.register_resource(
            ResourceArn=bucket_arn,
            UseServiceLinkedRole=True,
        )

        if response['ResponseMetadata']['HTTPStatusCode'] is 200:
            print(f"{bucket_arn} successfully registered")
        else:
            print(response)


if __name__ == "__main__":
    params = json.loads(sys.argv[1])
    lakeFormationController = LakeFormationController(params)
    LakeFormationController.create_lake_formation(lakeFormationController)
