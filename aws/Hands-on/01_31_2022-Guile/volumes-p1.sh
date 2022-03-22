# PART 1 - EXTEND EBS VOLUME WITHOUT PARTITIONING
# launch an instance from aws console
# check volumes which volumes attached to instance. 
# only root volume should be listed
lsblk
df -h
# create a new volume in the same AZ with the instance from aws console (2 GB for this demo).
# attach the new volume from aws console, then list block storages again.
# root volume and secondary volume should be listed
lsblk
df -h
# check if the attached volume is already formatted or not and has data on it.
sudo file -s /dev/xvdf
# if not formatted, format the new volume
sudo mkfs -t ext4 /dev/xvdf
# check the format of the volume again after formatting
sudo file -s /dev/xvdf
# create a mounting point path for new volume
sudo mkdir /mnt/2nd-vol
# mount the new volume to the mounting point path
sudo mount /dev/xvdf /mnt/2nd-vol/
# check if the attached volume is mounted to the mounting point path
lsblk
# show the available space, on the mounting point path
df -h
# check if there is data on it or not.
ls -lh /mnt/2nd-vol/
# if there is no data on it, create a new file to show persistence in later steps
cd /mnt/2nd-vol
sudo touch guilewashere.txt
ls
# modify the new volume in aws console, and enlarge capacity to double gb (from 2GB to 4GB for this demo).
# check if the attached volume is showing the new capacity
lsblk
# show the real capacity used currently at mounting path, old capacity should be shown.
df -h
# resize the file system on the new volume to cover all available space.
sudo resize2fs /dev/xvdf
# show the real capacity used currently at mounting path, new capacity should reflect the modified volume size.
df -h
# show that the data still persists on the newly enlarged volume.
ls -lh /mnt/2nd-vol/
# show that mounting point path will be gone when instance rebooted 
sudo reboot now
# show the new volume is still attached, but not mounted
lsblk
# check if the attached volume is already formatted or not and has data on it.
sudo file -s /dev/xvdf
# mount the new volume to the mounting point path
sudo mount /dev/xvdf /mnt/2nd-vol/
# show the used and available capacity is same as the disk size.
lsblk
df -h
# if there is data on it, check if the data still persists.
ls -lh /mnt/2nd-vol/