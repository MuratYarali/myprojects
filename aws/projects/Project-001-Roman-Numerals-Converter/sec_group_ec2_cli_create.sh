
sudo hostnamectl set-hostname aws-cli

bash

aws --version

- version2 yi yükleyelim:
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
/usr/local/bin/aws --version

aws configure

Access key ID: XXXXXXXXXXXXXXXXXXX
Secret access key: XXXXXXXXXXXXXXXXXXXXXXXXXXXXX
Default region name [None]: us-east-1
Default output format [None]: json

- konfigürasyonun tamamlandığını kontrol edelim:
aws sts get-caller-identity --query Account --output text

1. Security Groupların oluşturulması:

aws ec2 create-security-group \
    --group-name roman_numbers_sec_grp \
    --description "This Sec Group is to allow ssh and http from anywhere"

We can check the security Group with these commands:
aws ec2 describe-security-groups --group-names roman_numbers_sec_grp

You can check IPs with this command into the EC2:
curl https://checkip.amazonaws.com


2. Create Rules
aws ec2 authorize-security-group-ingress \
    --group-name roman_numbers_sec_grp \
    --protocol tcp \
    --port 22 \
    --cidr 0.0.0.0/0

aws ec2 authorize-security-group-ingress \
    --group-name roman_numbers_sec_grp \
    --protocol tcp \
    --port 80 \
    --cidr 0.0.0.0/0

3. After creating security Groups, We will create our EC2s. Latest AMI id should be used.

Bu en son AMIyi bulmak için kullanılacak komuttur.
- ilk olarak son ami bilgilerini çekelim
aws ssm get-parameters --names /aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2 --region us-east-1

- ikinci aşamada query çalıştırarak son ami numarasını elde edelim 
aws ssm get-parameters --names /aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2 --query 'Parameters[0].[Value]' --output text

- sonra bu değeri bir variable a atayalım:
LATEST_AMI=$(aws ssm get-parameters --names /aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2 --query 'Parameters[0].[Value]' --output text)

echo $LATEST_AMI

- userdata dosyamızı oluşturalım
sudo vim userdata.sh

#! /bin/bash
yum update -y
yum install python3 -y
pip3 install flask
cd /home/ec2-user
wget -P templates https://raw.githubusercontent.com/xxxxxxxx/my-projects-2/main/aws/projects/Project-001-Roman-Numerals-Converter/templates/index.html
wget -P templates https://raw.githubusercontent.com/xxxxxxxx/my-projects-2/main/aws/projects/Project-001-Roman-Numerals-Converter/templates/result.html
wget https://raw.githubusercontent.com/xxxxxxxx/my-projects-2/main/aws/projects/Project-001-Roman-Numerals-Converter/app.py
python3 app.py


-şimdi de instance ı çalıştıralım:
aws ec2 run-instances --image-id $LATEST_AMI --count 1 --instance-type t2.micro --key-name xxxxxxx --security-groups roman_numbers_sec_grp --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=roman_numbers}]' --user-data file:///Users/ODG/Desktop/git_dir/serdar-cw/porfolio_lesson_plan/week_6/CLI_solution/userdata.sh

veya

aws ec2 run-instances \
    --image-id $LATEST_AMI \
    --count 1 \
    --instance-type t2.micro \
    --key-name vincenzo \
    --security-groups roman_numbers_sec_grp \
    --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=roman_numbers}]' \
    --user-data file:///home/ec2-user/userdata.sh

- To see the each instances Ip we\'ll use describe instance CLI command:
aws ec2 describe-instances --filters "Name=tag:Name,Values=roman_numbers"

- You can run the query to find Public IP and instance_id of instances:
aws ec2 describe-instances --filters "Name=tag:Name,Values=roman_numbers" --query 'Reservations[].Instances[].PublicIpAddress[]'

aws ec2 describe-instances --filters "Name=tag:Name,Values=roman_numbers" --query 'Reservations[].Instances[].InstanceId[]'

- To delete instances:
aws ec2 terminate-instances --instance-ids xxxxxxxxxxxx

- To delete security groups:
aws ec2 delete-security-group --group-name roman_numbers_sec_grp



- dokumantasyon:
https://docs.aws.amazon.com/cli/latest/userguide
