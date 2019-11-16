#!/bin/bash

#################################################################################################################################
#################################################################################################################################
## Author: Vigneshwaran Gunasekaran
## Date: Oct 31, 2019
## This shell script will create users on the local system
## The user will be prompted to enter the username (login), name of the person, and a password
## The username, password, and host for the user will be displayed in the end
#################################################################################################################################
#################################################################################################################################

#Make sure that the script is executed with superuser (root) privileges.
#If the script is not executed with superuser privileges it will not attempt to create a user and returns an exit status of 1.
if [[ "${UID}" -ne 0 ]]
then
  echo "Please execute the script using sudo command or as root (superuser). Exiting the script now!"
  exit 1
fi


# Prompt the person who executed the script to enter the following:

# The username (login)
read -p "Enter the username: " USERNAME

# Get the real name (contents for the description field)
read -p "Enter the real name of the user: " REALNAME

# Get the password
read -p "Enter the password you would like to set for the user. Note: The user will be asked to reset the password during the first login: " PASSWORD


# Create a new user on the local system with the inputs provided by the user
useradd -c "${COMMENT}" -m ${USERNAME}

# Check to see if the useradd command succeeded.
if [[ "$?" -ne 0 ]]
then
  echo "The user cannot be created. Exiting the script now!"
  exit 1
fi

# Set the password.
echo ${PASSWORD} | passwd --stdin ${USERNAME}

# Check to see if the passwd command succeeded.
if [[ "$?" -ne 0 ]]
then
  echo "The password could not be set. Exiting the script now!"
  exit 1
fi


# Force password change on first login.
passwd -e ${USERNAME}

# Display the username, password, and host where the account was created.
echo "The new user creation is successful. Details of the new user are as follows:"
echo "The user name is: ${USERNAME}"
echo "The password is: ${PASSWORD}"
echo "The host server where the account was created is: `hostname`"

exit 0
