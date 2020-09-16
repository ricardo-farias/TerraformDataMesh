import pdb
import boto3


class LakeFormationController:

    def __init__(self):
        self.session = boto3.Session(profile_name='profile sparkapp')

        self.client = self.session.client(
            'lakeformation',
            region_name='us-east-2'
        )

    def create_lake_formation(self):
        self.overwrite_administrators("arn:aws:iam::233329490210:user/DataMeshPOC")
        self.grant_permissions("arn:aws:iam::233329490210:user/DataMeshPOC", 'Database', ["ALL"], ["ALL"])
        self.grant_permissions("arn:aws:iam::233329490210:user/DataMeshPOC", 'Database', ["ALL"], ["ALL"])
        self.grant_permissions("arn:aws:iam::233329490210:role/iam-emr-instance-profile-role", 'Database', ["ALL"])
        self.grant_permissions("arn:aws:iam::233329490210:role/iam-emr-instance-profile-role", 'Table', ["ALL"])
        self.register_all_resources(["arn:aws:s3:::data-mesh-covid-domain-atn/covid-italy",
                                     "arn:aws:s3:::data-mesh-covid-domain-atn/covid-us",
                                     "arn:aws:s3:::citi-bike-data-bucket-atn"])

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

    def grant_permissions(self, principal_arn, structure, permission_list=[], grant_permission_list=[]):
        #currently gives the principal access to all tables in datameshcatalogue (if structure is table)

        databaseName = 'datameshcatalogue'

        if structure == 'Table':
            resource = {
                'Table': {
                    'DatabaseName': databaseName,
                    'TableWildcard': {}
                }
            }

        elif structure == 'Database':
            resource = {
                'Database': {
                    'Name': databaseName
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
        print(response)

    def register_all_resources(self, resource_list):
        for resource in resource_list:
            try:
                self.register_resource_location(resource)
            except self.client.exceptions.AlreadyExistsException:
                print(f"Resource {resource} already exists")

    def register_resource_location(self, resource_location_arn):
        response = self.client.register_resource(
            ResourceArn=resource_location_arn,
            UseServiceLinkedRole=True,
        )
        print(response)

    def bulk_grant_permissions(self, principal_arn, permission_list=[], grant_permission_list=[]):
        #probably need to pass in resource/permissions as a dict?
        response = self.client.batch_grant_permissions(
            Entries=[
                {
                    'Id': 'Resource',
                    'Principal': {
                        'DataLakePrincipalIdentifier': principal_arn
                    },
                    'Resource': {
                        'Database': {
                            'Name': 'datameshcatalogue'  #parameter?
                        },
                        'Table': {
                            'DatabaseName': 'datameshcatalogue',
                            'TableWildcard': {}
                        }
                    },
                    'Permissions': permission_list,
                    'PermissionsWithGrantOption': grant_permission_list
                }
            ]
        )
        print(response)


if __name__ == "__main__":
    myController = LakeFormationController()
    LakeFormationController.create_lake_formation(myController)
