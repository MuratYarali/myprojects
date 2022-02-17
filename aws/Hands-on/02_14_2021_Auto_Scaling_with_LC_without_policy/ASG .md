# Hands-on EC2-07 : Configuring Application Load Balancer (ALB) with Auto Scaling Group (ASG) using Launch Configuration

Purpose of the this hands-on training is to give the students basic knowledge of how to configure AWS Load Balancers with Auto Scaling Group and Launch Configuration.

## Learning Outcomes

At the end of the this hands-on training, students will be able to;

- create load balancer with Target Group.

- create and configure Auto Scaling Group with Launch Configuration.

- add policy to Auto Scaling Group.

- add Cloudwatch alarm.

## Outline

- Part 1 - Create Security Group

- Part 2 - Create Target Group

- Part 3 - Create Application Load Balancer

- Part 4 - Create Launch Configuration

- Part 5 - Create Auto Scaling Group


![Load Balance and auto scaling](./LB_andautuscl.png)

## Part 1 - Create a Security Group

- Open the Amazon EC2 console at https://console.aws.amazon.com/ec2/.

- Choose the Security Groups on left-hand menu

- Click the `Create Security Group`.

```text
Security Group Name  : ALBSecGroup
Description          : ALB Security Group
VPC                  : Default VPC
Inbound Rules:
    - Type: SSH ----> Source: Anywhere
    - Type: HTTP ---> Source: Anywhere
Outbound Rules: Keep it as default
Tag:
    - Key   : Name
      Value : ALB Sec Group
```

- Click `Create Security Group` button.

## Part 2 - Create Launch Configuration

- Select `Launch Configurations` from the left-hand menu and then click `Create Launch Configuration` to start.

- We'll determine what we need to choose from disk size, IAM role, key pair to AMI type. We will do everything just like creating a new virtual machine.

- But at the end, we will not create a virtual machine. Instead, we'll actually save these things as a template and Auto Scaling will create a new instance according to this configuration when need.

- Step 1 - Choose AMI: `Linux 2 AMI`------> Search for "ami-033b95fb8079dc481" and select

- Step 2 - Choose Instance Type: `t2.micro`

- Step 3 - Configure Details:

  - Name: `First-Launch-Config`

  - Purchasing option Request: No need to Spot Instances.

  - IAM Role: -

  - Monitoring: We don't want to open Detailed Monitoring in, for now, so keep it as is.

  - Advanced Details:

    - User data

```bash

#!/bin/bash

#update os
yum update -y
#install apache server
yum install -y httpd
yum install -y wget
# get private ip address of ec2 instance using instance metadata
TOKEN=`curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600"` \
&& PRIVATE_IP=`curl -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/local-ipv4`
# get public ip address of ec2 instance using instance metadata
TOKEN=`curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600"` \
&& PUBLIC_IP=`curl -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/public-ipv4` 
# get date and time of server
DATE_TIME=`date`
# set all permissions 
chmod -R 777 /var/www/html
# create a custom index.html file
echo "<html>
<head>
    <title> ELB with Osvaldo</title>
</head>
<body>
    <h1>Testing Application Load Balancer and Autoscaling</h1>
    <p>This web server is launched from launch template by Clarusway</p>
    <p>This instance is created at <b>$DATE_TIME</b></p>
    <p>Private IP address of this instance is <b>$PRIVATE_IP</b></p>
    <p>Public IP address of this instance is <b>$PUBLIC_IP</b></p>
    <center><img src="ryu.jpg" alt="Welcome!"</center>
</body>
</html>" > /var/www/html/index.html
cd /var/www/html
wget https://raw.githubusercontent.com/awsdevopsteam/ngniex/master/ryu.jpg
# start apache server
systemctl start httpd
systemctl enable httpd
```

- Step 4 Choose Instance Type: `8 GB gp2`

- Step 5 Configure Security Group: Select the group named `ALBSecGroup`

- Step 6 - Review: Check the details of the configuration here.

- Click the `Create Launch Configuration` tab and pick a key pair. We confirm that we still have the key as we will continue with the existing one.

- Click `Create Launch Configuration` again.

## Part 3 - Create Target Group

- Go to `Target Groups` section under the Load Balancing part on left-hand menu and select `Target Group`

- Click `Create Target Group` button

  - Basic configuration

    ```text
    Choose a target type    : Instances
    Give Target Groups Name : MyTargetGroup
    Protocol                : HTTP
    Port                    : 80
    VPC                     : Default VPC
    ```

  - Health checks

    ```text
    Health check protocol   : HTTP
    Health check path       : /
    ```

  - Advance health check settings

    ```text
    Port                    : Traffic port
    Healthy threshold       : 3
    Unhealthy threshold     : 2
    Timeout                 : 5 seconds
    Interval                : 10 seconds
    Success codes           : 200
    ```

  - Tags

    ```text
    Key                     : Name
    Value                   : MyTargetGroup
    ```

- Click next

- Unlike Application Load Balancer hands-on, do not register any instances into the target group.

- Click `Create Target Group` button.

## Part 4 - Create Application Load Balancer

Go to the Load Balancing section on left-hand menu and select `Load Balancers`.

- Click `Create Load Balancer` tab.

- Select the `Application Load Balancer` option.

- Step 1: Configure Load Balancer

```text
Name            : MyALBforAutoScaling

Listeners       : A listener is a process that checks for connection requests, using the protocol and port that you configured.

Load Balancer Protocol      : HTTP
Load Balancer Port          : 80
Availability Zones          : Choose all AZ's

Add-on services             : Keep it as default
Tags                        :
    - Key   : Name
    - Value : MyALBforAutoScaling
```

- Step 2: Click `Next`: Configure Security Settings

```text
Since we didn't choose HTTPS for listener ports. we will see the warning:

!!! Improve your load balancers security. Your load balancer is not using any secure listener.!!!

We can leave it as is and click the `Next` button.
```

- Step 3: Configure Security Groups

  - Select an existing security group.

    ```text
    Name            :  ALBSecGroup
    ```

- Click `Next`: Configure Routing.

- Step 4: Configure Routing

```text
Target group        : Existing target group
Name                : MyTargetGroup

PS : MyTargetGroup that we created for Application Load Balancer. It will be same both for Application Load Balancer and Auto Scaling
```

When we select target group it is not necessary to adjust the rest of the settings, since we set all parts while creating the Target Group.

- Click `Next`: Register Targets.

- Click `Next` button.

- Review and if everything is ok, click the `Create` button.

```text
Successfully created load balancer!
```

- Click `Close`.

- Please wait for changing the state from `provisioning` to `active`.

## Part 5 - Create Auto Scaling Group (Create an Auto Scaling Group that keeps the target group in initial size)

- EC2 AWS Management console, select Auto Scaling Group from the left-hand menu and then click Create Auto Scaling Group

```text
Name: First-AS-Group.
```

Step 1: Choose launch template or launch configuration:

- Switch to the `Launch Configuration`, select newly created `First-Launch-Config`, and click `Next` to continue.

Step 2: Configure settings:

- Network

```text
VPC         : Default VPC
Subnets     : Select all Subnets
```

Step 3: Configure advanced options:

- Check `Enable Load Balancing` and Select `Application Load Balancer or Network Load Balancer` option

- Target Group: `MyTargetGroup`

- Health Check

```text
Health Check type           : ELB
Health check grace period   : 200 seconds
```

- Additional Settings : Keep it as default

Step 4: Configure group size and scaling policies:

- Group size

```text
Desired capacity        : 1
Minimum capacity        : 1
Maximum capacity        : 1
```

- Scaling policies

```text
None
```

- Instance scale-in protection

```text
Do not check
```

Step 5: Add notifications:

- Click on "Add Notification"

```text
Send a notification to:  my-sns-topic
With these recipients:   xxxxxx@clarusway.com
```


Step 6: Add Tags

```text
Key     : Name
Value:  : Autoscaling
```

Step 7: Review and create Auto Scaling Group.

- Confirm subscription email for notification first.

- Right click the `Instance` tap on left hand menu and open in new window and show the sub-sections and also show there is 1 instance created by auto scaling group,

- Right click the `Target Group` tap on left hand menu and open in new windows show the sub-sections and details. In Target Menu, show that the instance seems healthy based on rules that we set before.

- Right click the `Load Balancing` tap on left hand menu and open in new window show the sub-sections and details.

- Change the configuration of Autoscaling Group


Step 1:

- Go to Auto Scaling Groups and check the `ALBforAutoScaling` flag

- Click `Edit` Tab

- Change Values of Group Size

```text
Desired capacity    : 2
Minimum capacity    : 1
Maximum capacity    : 4
```

- Keep the rest of settings as default

- Click `Update`

Step 2:

- Show the changes in `instance number`, `activity tab` and `target group`.

- Go to `Instance Tab` on left hand-menu and show instances created by auto scaling group.

- Go to `Load Balancers` on the left-hand menu and copy Load Balancer DNS. Then paste it to browser, refresh the page and show the differences, like IP and dates.
- show the notification e-mail

Step 3: Observe that Autoscaling keeps the target group in initial size.

- Go to `Instance Tab` on left-hand menu and stop one of the instance.

- Go to `Target Group` on left-hand menu and click `MyTargetGroup`---> `Targets`.

- Show the status of the stopped instance and refresh it. It probably takes a while to create a new instance by Auto Scaling.

- Go to `Auto Scaling Groups` --> click `First-AS-Group` --> `Activity` and show the changes in the `Activity` history.

Step 4: Observe that Autoscaling keeps the target group in initial size.

- Make SSH connection to one of EC2 in target group.

- Check te status of httpd server. And Stop the httpd server.
```text
sudo systemctl status httpd
sudo systemctl stop httpd
```
- Go to the target group and show the Health Check
- Go to Auto Scaling Group -------> Activity History and show that The Instance ıs "Draining" 
- Explain why instance is running and Health check is Unhealthy. Show the listener is port. 
- Delete Auto-scaling group and Load Balancer
