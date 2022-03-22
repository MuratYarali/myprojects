# AWS CLI
# Guile - 02_21_2022

# References
# https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-welcome.html
### https://awscli.amazonaws.com/v2/documentation/api/latest/index.html
# https://aws.amazon.com/blogs/compute/query-for-the-latest-amazon-linux-ami-ids-using-aws-systems-manager-parameter-store/


# Installation
###
# https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html


# Win:
# https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html


# Mac:
# https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html
# https://graspingtech.com/install-and-configure-aws-cli/



# Linux:
# https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip  #install "unzip" if not installed
sudo ./aws/install
sudo yum install awscli -y



# Update AWS CLI Version 1 on Amazon Linux (comes default) to Version 2

# Remove AWS CLI Version 1
sudo yum remove awscli -y # pip uninstall awscli/pip3 uninstall awscli might also work depending on the image

# Install AWS CLI Version 2
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip  #install "unzip" if not installed
sudo ./aws/install

# Update the path accordingly if needed
export PATH=$PATH:/usr/local/bin/aws




# Configuration

aws configure

#ls -al than see ".aws" folder


    ##search for "aws cli reference" attantion for V2 
    https://docs.aws.amazon.com/cli/latest/index.html


cat .aws/config
cat .aws/credentials

#cd .aws
#cat config
#cat credentials

aws configure list-profiles


aws configure --profile user1

export AWS_PROFILE=user1
export AWS_PROFILE=default

aws configure list-profiles ????

aws sts get-caller-identity #cd

    ##aws help
    ##aws <command> help ==>>> aws s3 help
    ##aws <command> <subcommand> help ==>>> aws s3 mb help


# IAM
aws iam list-users
    ##look at aws consol iam 
aws iam create-user --user-name aws-cli-user

aws iam delete-user --user-name aws-cli-user


# S3
aws s3 ls

aws s3 mb s3://hrn-bucket

aws s3 cp in-class.yaml s3://hrn-bucket (lokal konsolda aç, dosyanın konumuna gel)

## aws s3 ls s3://test-hrn1 --recursive

aws s3 ls s3://hrn-bucket

aws s3 rm s3://hrn-bucket/in-class.yaml

aws s3 rm s3://bucket-name --recursive

aws s3 rb s3://hrn-bucket        !!!!
aws s3 rb s3://test-hrn1 --force
delete: s3://test-hrn1/test22.txt
delete: s3://test-hrn1/test12.txt
remove_bucket: test-hrn1





# EC2
aws ec2 describe-instances
###https://awscli.amazonaws.com/v2/documentation/api/latest/reference/ec2/describe-instances.html
###https://docs.aws.amazon.com/cli/latest/userguide/cli-services-ec2-sg.html#creating-a-security-group

##
aws ec2 run-instances \
   --image-id ami-033b95fb8079dc481 \
   --count 2 \
   --instance-type t2.micro \
   --key-name FirstKey  # put your key name 
##



aws ec2 describe-instances \
   --filters "Name = key-name, Values = FirstKey" # put your key name

## https://awscli.amazonaws.com/v2/documentation/api/latest/reference/ec2/describe-instances.html

## --dry-run 
## --dry-run | --no-dry-run (boolean)
aws ec2 describe-instances --dry-run
An error occurred (DryRunOperation) when calling the Descrces operation: Request would have succeeded, but DryRun fl

## Checks whether you have the required permissions for the action, without actually making the request, and provides an error response. If you have the required permissions, the error response is DryRunOperation . Otherwise, it is UnauthorizedOperation .

##Query
aws ec2 describe-instances --query "Reservations[].Instances[].PublicIpAddress[]"

      ##Filter
aws ec2 describe-instances \
   --filters "Name = key-name, Values = KEY_NAME_HERE" --query "Reservations[].Instances[].PublicIpAddress[]" # put your key name



##
aws ec2 describe-instances \
 --filters "Key Name = firstkey"
##


aws ec2 describe-instances \
   --filters "Name = instance-type, Values = t2.micro" --query "Reservations[].Instances[].InstanceId[]"


aws ec2 stop-instances --instance-ids INSTANCE_ID_HERE # put your instance id

aws ec2 terminate-instances --instance-ids INSTANCE_ID_HERE # put your instance id



# Working with the latest Amazon Linux AMI

aws ssm get-parameters --names /aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2 --region us-east-1

aws ssm get-parameters --names /aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2 --query 'Parameters[0].[Value]' --output text

###
https://docs.aws.amazon.com/systems-manager/latest/userguide/sysman-paramstore-access.html
https://docs.aws.amazon.com/cli/latest/reference/ssm/get-parameters.html

aws ssm get-parameters \
    --names "MyStringParameter" "MyStringListParameter" "MyInvalidParameterName"

aws ssm get-parameters \
    --names MyStringParameter MyStringListParameter \
    --query "Parameters[*].{Name:Name,Value:Value}"


###















## Derssonu ilaveler 

https://www.bluematador.com/learn/aws-cli-cheatsheet




