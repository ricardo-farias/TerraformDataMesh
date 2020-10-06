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
        self.add_administrator(self.lf_admin)
        self.grant_permissions(self.lf_admin, 'Database', ["ALL"], ["ALL"])
        self.grant_permissions(self.lf_admin, 'Table', ["ALL"], ["ALL"])
        self.grant_permissions(self.emr_instance_profile, 'Database', ["ALL"])
        self.grant_permissions(self.emr_instance_profile, 'Table', ["ALL"])
        self.register_all_resources(self.s3_domain_locations)

    def destroy_lake_formation(self):
        self.deregister_all_resources(self.s3_domain_locations)
        # self.remove_permissions(self.lf_admin, 'Database', ["ALL"], ["ALL"])
        self.remove_permissions(self.lf_admin, 'Table', ["ALL"], ["ALL"])
        self.remove_permissions(self.emr_instance_profile, 'Database', ["ALL"])
        self.remove_permissions(self.emr_instance_profile, 'Table', ["ALL"])
        # self.remove_administrator(self.lf_admin)


    # def overwrite_administrators(self, admin_arn):
    #     response = self.client.put_data_lake_settings(
    #         DataLakeSettings={
    #             'DataLakeAdmins': [
    #                 {
    #                     'DataLakePrincipalIdentifier': admin_arn
    #                 },
    #             ]
    #         }
    #     )
    #     if response["ResponseMetadata"]["HTTPStatusCode"] == 200:
    #         print(f"AWS Lake Formation Administrator set to {admin_arn}")
    #     else:
    #         print(response)

    def add_administrator(self, lf_admin):
        data_lake_settings = self.client.get_data_lake_settings()
        current_administrators = data_lake_settings["DataLakeSettings"]["DataLakeAdmins"]
        if {'DataLakePrincipalIdentifier': lf_admin} not in current_administrators:
            current_administrators.append({'DataLakePrincipalIdentifier': lf_admin})
            response = self.client.put_data_lake_settings(DataLakeSettings=data_lake_settings["DataLakeSettings"])
            if response["ResponseMetadata"]["HTTPStatusCode"] == 200:
                print(f"{lf_admin} is now an AWS Lake Formation Administrator")
            else:
                print(response)
        else:
            print(f"{lf_admin} is already a Lake Formation Administrator")

    def remove_administrator(self, lf_admin):
        data_lake_settings = self.client.get_data_lake_settings()
        administrators = data_lake_settings["DataLakeSettings"]["DataLakeAdmins"]
        try:
            administrators.remove({'DataLakePrincipalIdentifier': lf_admin})
        except ValueError:
            print(f"{lf_admin} was not an AWS Lake Formation Administrator")
        response = self.client.put_data_lake_settings(DataLakeSettings=data_lake_settings["DataLakeSettings"])
        if response["ResponseMetadata"]["HTTPStatusCode"] == 200:
            print(f"{lf_admin} is no longer an AWS Lake Formation Administrator")
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

        if response['ResponseMetadata']['HTTPStatusCode'] == 200:
            print(f"Permissions for {resource} granted to {principal_arn}")
        else:
            print(resource, response)

    def remove_permissions(self, principal_arn, structure, permission_list=[], grant_permission_list=[]):
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

        try:
            response = self.client.revoke_permissions(
                Principal={
                    'DataLakePrincipalIdentifier': principal_arn
                },
                Resource=resource,
                Permissions=permission_list,
                PermissionsWithGrantOption=grant_permission_list
            )
            if response['ResponseMetadata']['HTTPStatusCode'] == 200:
                print(f"Permissions revoked from {principal_arn}")
            else:
                print(resource, response)
        except self.client.exceptions.InvalidInputException:
            print(f"Permissions for {principal_arn} to {resource} were not revoked because they did not exist")

    def register_all_resources(self, resource_list):
        for resource in resource_list:
            bucket_arn = f"arn:aws:s3:::{resource}"
            try:
                self.register_resource_location(bucket_arn)
            except self.client.exceptions.AlreadyExistsException:
                print(f"Resource {bucket_arn} already exists")

    def register_resource_location(self, bucket_arn):
        response = self.client.register_resource(
            ResourceArn=bucket_arn,
            UseServiceLinkedRole=True,
        )

        if response['ResponseMetadata']['HTTPStatusCode'] == 200:
            print(f"{bucket_arn} successfully registered")
        else:
            print(response)

    def deregister_all_resources(self, resource_list):
        for resource in resource_list:
            bucket_arn = f"arn:aws:s3:::{resource}"
            try:
                self.deregister_resource_location(bucket_arn)
            except self.client.exceptions.EntityNotFoundException:
                print(f"Resource {bucket_arn} was not a registered resource")

    def deregister_resource_location(self, bucket_arn):
        response = self.client.deregister_resource(
            ResourceArn=bucket_arn,
        )

        if response['ResponseMetadata']['HTTPStatusCode'] == 200:
            print(f"{bucket_arn} successfully deregistered")
        else:
            print(response)


if __name__ == "__main__":
    create_or_destroy = sys.argv[1]
    if sys.argv[2] == 'testing':
        params = json.loads(
            '{ "db_name": "datameshatndatameshcatalogue", '
            '"account_id":"233329490210", '
            '"lf_admin":"DataMeshPOC", '
            '"s3_domain_locations":['
            '"datamesh-atn-covid-domain/covid-italy",'
            '"datamesh-atn-covid-domain/covid-us",'
            '"datamesh-atn-bike-domain"]'
            '}'
        )
    else:
        params = json.loads(sys.argv[2])
    lakeFormationController = LakeFormationController(params)
    if create_or_destroy == 'create':
        LakeFormationController.create_lake_formation(lakeFormationController)
    elif create_or_destroy == 'destroy':
        LakeFormationController.destroy_lake_formation(lakeFormationController)
    else:
        print('please pass either destroy or create as first variable')
