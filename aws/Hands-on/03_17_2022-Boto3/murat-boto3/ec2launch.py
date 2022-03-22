import boto3
ec2 = boto3.resource('ec2')

instances = ec2.create_instances(
        ImageId='ami-0c02fb55956c7d316',
        MinCount=1,
        MaxCount=1,
        InstanceType='t2.micro',
        KeyName='firstkey'
)
