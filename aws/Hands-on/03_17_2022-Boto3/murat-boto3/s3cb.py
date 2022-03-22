import boto3

s3 = boto3.resource('s3')

s3.create_bucket(Bucket='murat-boto3')

for bucket in s3.buckets.all():
        print(bucket.name)
