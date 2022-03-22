# AWS CLI
# Guile - 02_21_2022

# References
# https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-welcome.html
# https://awscli.amazonaws.com/v2/documentation/api/latest/index.html
# https://aws.amazon.com/blogs/compute/query-for-the-latest-amazon-linux-ami-ids-using-aws-systems-manager-parameter-store/



# Installation

# https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html

# Win:
# https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html


# Mac:
# https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html
# https://graspingtech.com/install-and-configure-aws-cli/


# Linux:
# https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html


https://docs.aws.amazon.com/cli/latest/index.html


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

#after "aws configure" following options
  AWS Access Key ID [None]:
  AWS Secret Access Key [None]:
  Default region name [None]: us-east-1
  Default output format [None]: yaml

# Configuration

aws configure

cat .aws/config
cat .aws/credentials


aws configure

#after "aws configure" following options
  AWS Access Key ID [****************MXZI]: 
  AWS Secret Access Key [****************Rlrs]: 
  Default region name [us-east-1]:
  Default output format [yaml]:


aws configure --profile user1
#after "aws configure --profile user1" following options
  AWS Access Key ID [None]: qqqqq
  AWS Secret Access Key [None]: wwwww
  Default region name [None]: eu-east-1
  Default output format [None]: json

#Setting the environment variable changes the value used until the end of your shell session, or until you set the variable to a different value. You can make the variables persistent across future sessions by setting them in your shell's startup script.
export AWS_PROFILE=user1
export AWS_PROFILE=default

export AWS_ACCESS_KEY_ID=AKIAIOSFODNN7EXAMPLE
export AWS_SECRET_ACCESS_KEY=wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
export AWS_DEFAULT_REGION=us-west-2

aws configure list-profiles 
(How many profile are there?)

aws configure --profile user1

export AWS_PROFILE=user1
export AWS_PROFILE=default

aws configure list-profiles

aws sts get-caller-identity

# IAM
aws iam list-users

aws iam create-user --user-name aws-cli-user

aws iam delete-user --user-name aws-cli-user


# S3
aws s3 ls

aws s3 mb s3://guile-cli-bucket

aws s3 cp in-class.yaml s3://guile-cli-bucket

aws s3 ls s3://guile-cli-bucket

aws s3 ls s3://murat-cli-bucket/ --recursive 

aws s3 rm s3://guile-cli-bucket/in-class.yaml

aws s3 rb s3://guile-cli-bucket

aws s3 rb s3://murat-cli-bucket/ --force


# EC2
aws ec2 describe-instances

aws ec2 run-instances \
   --image-id ami-033b95fb8079dc481 \
   --count 1 \
   --instance-type t2.micro \
   --key-name KEY_NAME_HERE # put your key name

aws ec2 describe-instances \
   --filters "Name = key-name, Values = KEY_NAME_HERE" # put your key name

aws ec2 describe-instances --query "Reservations[].Instances[].PublicIpAddress[]"

aws ec2 describe-instances \
   --filters "Name = key-name, Values = KEY_NAME_HERE" --query "Reservations[].Instances[].PublicIpAddress[]" # put your key name

aws ec2 describe-instances \
   --filters "Name = instance-type, Values = t2.micro" --query "Reservations[].Instances[].InstanceId[]"

aws ec2 stop-instances --instance-ids INSTANCE_ID_HERE # put your instance id

aws ec2 terminate-instances --instance-ids INSTANCE_ID_HERE # put your instance id

# Working with the latest Amazon Linux AMI

aws ssm get-parameters --names /aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2 --region us-east-1

aws ssm get-parameters --names /aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2 --query 'Parameters[0].[Value]' --output text

aws ec2 run-instances \
   --image-id $(aws ssm get-parameters --names /aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2 --query 
'Parameters[0].[Value]' --output text) \
   --count 1 \
   --instance-type t2.micro

## --dry-run 
## --dry-run | --no-dry-run (boolean)
aws ec2 describe-instances --dry-run
An error occurred (DryRunOperation) when calling the Descrces operation: Request would have succeeded, but DryRun fl

aws ec2 terminate-instances --instance-ids i-010e26e7464ddfbb5 --dry-run

aws ec2 stop-instances --instance-ids i-010e26e7464ddfbb5 --dry-run

## Checks whether you have the required permissions for the action, without actually making the request, and provides an error response. If you have the required permissions, the error response is DryRunOperation . Otherwise, it is UnauthorizedOperation .

# Update AWS CLI Version 1 on Amazon Linux (comes default) to Version 2

# Remove AWS CLI Version 1
sudo yum remove awscli -y # pip uninstall awscli/pip3 uninstall awscli might also work depending on the image

# Install AWS CLI Version 2
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip  #install "unzip" if not installed
sudo ./aws/install

# Update the path accordingly if needed
export PATH=$PATH:/usr/local/bin/aws
