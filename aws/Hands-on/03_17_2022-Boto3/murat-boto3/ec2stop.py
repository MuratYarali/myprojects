import boto3
ec2 = boto3.resource('ec2')
ec2.Instance('i-0321734c7c5a909f9').stop()
