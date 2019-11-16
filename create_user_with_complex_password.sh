#!/bin/bash

#################################################################################################################################
#################################################################################################################################
## Author: Vigneshwaran Gunasekaran
## Date: Nov 1, 2019
## This shell script will create users on the local system
## The user will be prompted to enter the username (login) followd by comments (whch may contain any no. of words)
## A complex password will be auto set by the script for the user
## Upon successful execution, the username, password, and host for the user will be displayed in the end
#################################################################################################################################
#################################################################################################################################

# Enforce that the script is executed with superuser (root) privileges. If the script is not executed with
# superuser privileges it will not attempt to create a user and returns an exit status of 1.
if [[ "${UID}" -ne 0 ]]
then
  echo "ERROR! Please execute the script using sudo or login as root (superuser). Exiting the script now!"
  exit 1
fi

# If the user doesn't supply at least one argument, then give them help.
# Provides a usage statement much like you would find in a man page if the user does not supply an account name on the command line
# and returns an exit status of 1.
if [[ "${#}" -lt 1 ]]
then
  echo "ERROR! Correct usage of this script is as follows:"
  echo "./add-new-local-user.sh USERNAME [COMMENT]..."
  exit 1
fi

# The first argument provided on the command line is the user name.
USERNAME="${1}"

# All the arguments following the first argument are for the comments for the account.
shift
COMMENT="${@}"

# Generate a password.
PASSWORD=$(date +%s%N${RANDOM}${RANDOM} | sha256sum | head -c8)

# Create the user with the password.
useradd -c "${COMMENT}" -m ${USERNAME}

# Check to see if the useradd command succeeded.
if [[ "${?}" -ne 0 ]]
then
  echo "ERROR! The user creation failed. Exiting the script now!"
  exit 1
fi

# Set the password
echo ${PASSWORD} | passwd --stdin ${USERNAME}

# Check to see if the passwd command succeeded.
if [[ "${?}" -ne 0 ]]
then
  echo "ERROR! The password could not be set. Exiting the script now!"
  exit 1
fi

# Force password change on first login.
passwd -e ${USERNAME}

# Display the username, password, and the host where the user was created.
echo "SUCCESS! New user account created successfully"
echo "User Name: ${USERNAME}"
echo "Password: ${PASSWORD}"
echo "Hostname: $(hostname)"

exit 0
