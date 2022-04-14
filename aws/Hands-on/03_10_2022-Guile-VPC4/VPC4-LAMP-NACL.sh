# PART 1 : Creating LAMP stack with Wordpress

# 1.Create Sec.Groups:

   Wordpress-BastionHost-SG: In bound : "SSH 22, HTTP 80,   > anywhere(0:/00000)"
   MariaDB-SG: In bound :"Mysql 3306, SSH 22  > anywhere (0:/00000)"
   NAT-SG: In bound : "HTTP, HTTPS, SSH 22  > anywhere (0:/00000)" # No need for NAT-SG if you use NAT Gateway.

# 2.Create EC2 that is installed LAMP with user data seen below for "Wordpress app in Public Subnet 1b"

   VPC: "clarus-vpc-a"
   Subnet: "clarus-az1b-public-subnet"
   Sec Group: "Wordpress-BastionHost-SG"
   User Data:
   
#!/bin/bash

yum update -y
amazon-linux-extras install -y lamp-mariadb10.2-php7.2 php7.2
yum install -y httpd
systemctl start httpd
systemctl enable httpd
wget https://wordpress.org/latest.tar.gz
tar -xzf latest.tar.gz
sudo cp -r wordpress/* /var/www/html/
cd /var/www/html/
cp wp-config-sample.php wp-config.php
chown -R apache /var/www
chgrp -R apache /var/www
chmod 775 /var/www
find /var/www -type d -exec sudo chmod 2775 {} \;
find /var/www -type f -exec sudo chmod 0664 {} \;
systemctl restart httpd

# 3.Create MariaDB ec2 instance in Private Subnet 1b

   VPC: "clarus-vpc-a"
   Subnet: "clarus-az1b-private-subnet"
   Sec Group: "MariaDB-SG"
   User Data:

#!/bin/bash

yum update -y
yum install -y mariadb-server
systemctl start mariadb
systemctl enable mariadb


# 4. Control the instance status.

# 5. To establish a more secure connection between the Wordpress instance and the DB instance, configure  
# the DB instance security group inbound rule to ensure it only permits Wordpress instance security group to access.

Rule: Mysql 3306, SSH 22  >>>>>> "anywhere (0:/00000)"

							        V
 							        V
 							        V
 							 
Rule: Mysql 3306, SSH 22  >>>>>> "Wordpress-BastionHost-SG"

# 6. To connect to private instance first we need to connect to the Wordpress instance (Bastion Host).
# You can copy/transfer your .pem file to the Wordpress instance.

- connect to Wordpress instance
- create a .pem file with the same name of your .pem file 
   -sudo vi key.pem
- open the .pem file in local with text editor
- copy the text file
- paste it in to the vi file
- Esc :wq ---> Enter
- chmod 400 KEY_NAME_HERE.pem 
- ssh ec2-user@"privateIP of private instance that you want to connect"

"OR" 

You can use "scp" to transfer your .pem key.

"OR" 

# 7. Type following code to start ssh-agent.
eval "$(ssh-agent)"

# 8. Add your private key to the ssh agent.
ssh-add KEY_NAME_HERE.pem # Be careful about the path of your key, use relative or absolute path.

# 9. Connect to the "Wordpress-Bastion Host" instance in "public-1b" subnet.
ssh -A ec2-user@3.88.199.43 (Public IP of Wordpress-Bastion Host) # Don't forget to change the IP with your instance IP.

# 10. connect to the Database instance in the "private-1b" subnet.
ssh ec2-user@10.7.2.20 (Private IP of Database Instance) # Don't forget to change the IP with your instance IP.

# 11. Check if the yum update and mariadb installation were done with userdata.
sudo systemctl status mariadb

# No, because there is no outbound connectivity. Try to do it manually, it will not work that way, too.

sudo yum update -y
sudo yum install -y mariadb-server
	
# 12. Create NAT instance in "Public Subnet 1a" (Other public subnets will also work).
# (You can also create a NAT Gateway for outbound connectivity)

    AMI: "NAT"
    VPC: "clarus-vpc-a"
    Subnet: "clarus-az1a-public-subnet"
    Sec Group: "NAT-SG"

# 13. Edit "clarus-private-rt" route table:

Destination                 Target
10.7.0.0/16    >>>>>>       local
0.0.0.0/0      >>>>>>       Instance >> NAT instance # (Select NAT Gateway if you use NAT Gateway)

# 14. Select Nat instance, click Networking from the Actions menu and then go to Change Source/Destination Check.

Check "Stop" option from the pane.

# 15. Install mariadb server to "DB instance".

sudo yum update -y
sudo yum install -y mariadb-server
sudo systemctl start mariadb
sudo systemctl enable mariadb
    
----> Warning!!! To be able to upload/update packages, http/https must be allowed in NAT Instance security group. 

# 16. Setup secure installation of MariaDB.
sudo mysql_secure_installation # Set root pwd: "root1234", and "y" to all questions.

# 17. Connect mysql terminal with password (pwd: "root1234").
mysql -u root -p

# 18. Show databases.
SHOW DATABASES;

# 19. Create new database named "clarusdb".
CREATE DATABASE clarusdb;

# 20. Create a user named "admin".
CREATE USER admin IDENTIFIED BY '123456789';

# 21. Grant permissions to the user "admin" for database "clarusdb".
GRANT ALL ON clarusdb.* TO admin IDENTIFIED BY '123456789' WITH GRANT OPTION;  

# 22. Update privileges.
FLUSH PRIVILEGES;

# 23. Select mysql.
USE mysql;

# 24. List the users defined.
SELECT Host, User, Password FROM user;

# 25. Close mysql cli.
EXIT;

# 26. Return back to "Wordpress Instance" to configure Word press database settings.
cd /var/www/html/

# 27. Change the config file for database association and restart httpd (You can use your favorite editor).
sudo vi wp-config.php

     define( 'DB_NAME', 'clarusdb' );

     define( 'DB_USER', 'admin' );

     define( 'DB_PASSWORD', '123456789' );

     define( 'DB_HOST', 'PRIVATE_IP_OF_MARIADB' );

Esc :wq ---> Enter

sudo systemctl restart httpd

# 28. Check the browser using the WordPress instance Public Ip.
# You will see the home page of Wordpress. Enter pasword,user name etc... Introduce WordPress.

---------------------------------------------------------------------------------------

# PART 2 : Configuring NACL (Network Access Control List)

# 1. Create a private ec2 instance in Private Subnet 1a

    VPC: "clarus-vpc-a"
    Subnet: "clarus-az1a-private-subnet"
    Sec Group: Allow >>> "SSH and All ICMP-IPv4"

# 2. Go to the 'Network ACLs' menu from left hand pane on VPC

# 3. Click 'Create network ACL' button

    Name: "clarus-private1a-nacl"
    VPC: "clarus-vpc-a"

- Select Inbound Rules ---> Edit Inbound rules ---> Add Rule
  Rule        Type              Protocol      Port Range        Source      Allow/Deny
  100         ssh(22)           TCP(6)        22                0.0.0.0/0   Allow
  200         All ICMP - IPv4   ICMP(1)       ALL               0.0.0.0/0   Allow


- Select Outbound Rules ---> Edit Outbound rules ---> Add Rule
  Rule        Type              Protocol      Port Range        Destination      Allow/Deny
  100         ssh(22)           TCP(6)        22                0.0.0.0/0         Allow
  200         All ICMP - IPv4   ICMP(1)       ALL               0.0.0.0/0         Deny

# 4. Select Subnet associations sub-menu ---> Edit subnet association ---> select "clarus-az1a-private-subnet" ---> edit

# 5. Go to terminal, ssh to the WordPress/BastionHost instance and try to ping private instance.
ping 10.7.2.20 (Private IP of Private Instance) # Don't forget to change the IP with your instance IP. 

# It will not work because of the NACLs outbound rule DENY.

# 6. Go to the NACL named "clarus-private1a-nacl"

# 7. Select Outbound Rules ---> Edit Outbound rules

  Rule        Type              Protocol      Port Range        Destination      Allow/Deny
  100         ssh(22)           TCP(6)        22                0.0.0.0/0         Allow
  200         All ICMP - IPv4   ICMP(1)       ALL               0.0.0.0/0         Deny
  |                                         |                                   |
  |                                         |                                   |
  V                                         V                                   V
  100         ssh(22)           TCP(6)        22                0.0.0.0/0         Allow
  200         All ICMP - IPv4   ICMP(1)       ALL               0.0.0.0/0         Allow

# 8. Show you can ping private instance now.
ping 10.7.2.20 (Private IP of Private Instance) # Don't forget to change the IP with your instance IP.

# 9. Try to ssh to private instance over the WordPress/BastionHost instance.
# It will not work because of the ephemeral ports. Explain ephemeral ports.

# 10. Go to the NACL named "clarus-private1a-nacl"

# 11. Select Outbound Rules ---> Edit Outbound rules

  Rule        Type              Protocol      Port Range        Destination      Allow/Deny
  100         ssh(22)           TCP(6)        22                0.0.0.0/0         Allow
  200         All ICMP - IPv4   ICMP(1)       ALL               0.0.0.0/0         Allow
  |                                         |                                   |
  |                                         |                                   |
  V                                         V                                   V
  100         Custom TCP Rule   TCP(6)        32768 - 65535     0.0.0.0/0         Allow
  200         All ICMP - IPv4   ICMP(1)       ALL               0.0.0.0/0         Allow

# 12. Click save, go to the terminal and ssh to the private EC2 instance. Show you can ssh to it now.

# 13. Terminate the resources you have created.

********************************************"!!!WARNING!!!"*********************************************
********************************************************************************************************
!!!!!!!!!!!!!!!!!!!"DONT FORGET TO TERMINATE/DELETE THE RESOURCES THAT YOU HAVE CREATED!"!!!!!!!!!!!!!!!
********************************************************************************************************
********************************************************************************************************