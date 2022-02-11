# Teamwork-Project-01 : Working with EC2 Snapshots, AMIs and Volumes

Purpose of the this project is to learn how to take a snapshot of EC2 instance, create an image and volume (root and additional volumes), creating new volume and instance from these snapshots, attaching and mounting new volume and instance together.

## Learning Outcomes

- At the end of the this hands-on training, students will be able to;

- take snapshots of EC2 instance and volume on AWS console.

- create images from EC2 instances on AWS console.

- understand of difference between the image and the snapshot.

- create different types of AMI.

- coping and sharing AMI

- formatting and resizing additional volume and mounting with root volume 

- attaching and mounting new volume and instance together

## Outline

Part 1 - Creating an EC2 instance (EC2A) with an additional volume (10 GiB)

Part 2 - Mounting the additional volume and adding a test.txt file to additional volume

Part 3 - Taking snapshot of the EC2 (EC2A) with 2 volumes

Part 4 - Create an instance (EC2B) from root volume's snapshop of EC2A

Part 5 - Create an new volume (15 GiB) from additional volume's snapshop of EC2A

Part 6 - Mount EC2B and additional volume (15 GiB)

## Part 1 - Creating an EC2 instance (EC2A) with an additional volume (10 GiB)

-  Launch an instance name EC2A with following configurations.
    
    Step 1: select Amazon Linux 2 AMI
    Step 2: select t2.micro
    Step 3: For further steps note your Subnet region 
    Step 4: Add New Volume; Volume Type: EBS, Size 10 GiB (Note; your device column name "/dev/sdb)
    Step 5: Tag; Name, EC2_
    Step 6: Configure Security Group; Type: SHH Port: 22
    Step 7: Creat


## Part 2 - Mounting the additional volume

  - Connect EC2A via ssh from terminal.

# check volumes which volumes attached to instance. 
lsblk
df -h
# check if the attached volume is already formatted or not and has data on it.
sudo file -s /dev/xvdb
# if not formatted, format the new volume
sudo mkfs -t ext4 /dev/xvdb
# check the format of the volume again after formatting
sudo file -s /dev/xvdb
# create a mounting point path for new volume
sudo mkdir /mnt/2nd-vol
# mount the new volume to the mounting point path
sudo mount /dev/xvdb /mnt/2nd-vol
# check if the attached volume is mounted to the mounting point path
lsblk
# show the available space, on the mounting point path
df -h
# check if there is data on it or not.
ls -lh /mnt/2nd-vol/
# Adding a test.txt file to additional volume
cd /mnt/2nd-vol
sudo vi test.txt
# write the text --> "Your_Name was Here..!" in the test.txt
# read and check "Your_Name was Here..!" 
cat test.txt 

## Part 3 - Taking snapshot of the EC2 (EC2A) with 2 volumes

Go to "Elastic Block Store" on left hand menu
Click "snapshots"
Click "Create snapshot"

Select Instance
  Instance ID: EC2A
  Description: EC2A Snapshot
  Root volume: Include
  Tag: Name, EC2A_Instance_Snapshot

## Part 4 - Create an instance (EC2B) from root volume's snapshop of EC2A

Select "RootVolumeSnapshot" (8 GiB)
  Actions --> create image from snapshot
    Image name: Image_for_EC2B
    Description: Image_for_EC2B
    
    Click "Create image"

Go to AMIs on left hand menu
Select "Image_for_EC2B"
  Click "Launch instance from image"
    Step 3: Configure Instance Details --> Subnet: Default in us-east-1a
    Step 5: Add Tags --> Name, EC2B
    Step 6: Configure Security Group; Type: SHH Port: 22
    Click "launch"


## Part 5 - Create an new volume (15 GiB) from additional volume's snapshop of EC2A

Go to "Elastic Block Store" on left hand menu
Click "snapshots"
  Select "AdditionalVolumeSnapshot" (10 GiB)
    Actions --> create volume from snapshot
      Size (GiB): 15
      Availability Zone: us-east-1a
      Tags: Name, new_add_vol
      Click "Create volume"

Go to "Elastic Block Store" on left hand menu
Click "Volumes"
Select "new_add_vol"
  Actions --> "attach volume"
    Instance: EC2B

    Click "Attach volume"


## Part 6 - Mount EC2B and additional volume (15 GiB)

  - Connect EC2B via ssh from terminal
  (Note: Don't forget change username from root to ec2-user eg.;
  ssh -i "firstkey.pem" `root`@ec2-44-200-218-109.compute-1.amazonaws.com) (wrong format)
  ssh -i "firstkey.pem" `ec2-user`@ec2-44-200-218-109.compute-1.amazonaws.com) (correct format)

# check volumes which volumes attached to instance. 
lsblk
df -h
# create a mounting point path for new volume
sudo mkdir /mnt/3nd-vol
# mount the new volume to the mounting point path
sudo mount /dev/xvdf /mnt/3nd-vol
# check if there is data on it or not.
ls -lh /mnt/3nd-vol/
# read and check "Your Name was Here..!" in test.txt 
cd /mnt/3nd-vol
cat test.txt
# resize the volume to 15GiB (add 5 GiB to this partition)
sudo resize2fs /dev/xvdf 
# check if the attached volume is mounted to the mounting point path
lsblk
# show the available space, on the mounting point path
df -h