#!/bin/bash

# This script creates a new user on the local system.
# You will be prompted to enter the username (login), the person name, and a password.
# The username, password, and host for the account will be displayed.

# Make sure the script is being executed with superuser privileges.

if [[ "$UID" -ne 0 ]]
then
  echo "Please run this command with sudo" 
  exit
fi

# Get the username (login).
read -p "Please Enter Username : " username
# Get the comment (contents for the description field).
read -p "Please Enter the comment : " comment
# Get the password.
read -s -p "Please Enter Password : " password
# Create the account.
useradd -c $comment -m $username
# Check to see if the useradd command succeeded.
# We don't want to tell the user that an account was created when it hasn't been.

if [[ $? -eq 0 ]]
then
  echo "Success! User has been created"
fi
# Set the password.
echo $password | passwd --stdin $username
# Check to see if the passwd command succeeded.
if [[ $? -eq 0 ]]
then
  echo "password Success!" 
fi
# Force password change on first login.
passwd -e $username
# Display the username, password, and the host where the user was created.
echo -e "Your username: $username
Your password: $password
Hostname : $HOSTNAME"