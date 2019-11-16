#!/bin/bash

#################################################################################################################################
#################################################################################################################################
## Author: Vigneshwaran Gunasekaran
## Date: Nov 2, 2019
## This shell script will create users on the local system
## The user will be prompted to enter the username (login) followd by comments (whch may contain any no. of words)
## A complex password will be auto set by the script for the user
## Upon successful execution, the username, password, and host for the user will be displayed in the end
#################################################################################################################################
#################################################################################################################################

# Ensure that the script is executed with superuser (root) privileges.
# If the script is not executed with superuser privileges it will not attempt to create a user and returns an exit status of 1.
# All messages associated with this event will be displayed on standard error.
if [[ "${UID}" -ne 0 ]]
then
  echo "ERROR! Execute the script using sudo or as superuser (root). Exiting script now." >&2
  exit 1
fi

# If the user doesn't supply at least one argument, provides a usage statement and returns an exit status of 1.
# All messages associated with this event will be displayed on standard error.
if [[ "${#}" -lt 1 ]]
then
  echo "ERROR! Incorrect usage of the script. Please follow below usage. Exiting script now" >&2
  echo "${0} USERNAME [COMMENT]..." >&2
  exit 1
fi

# Uses the first argument provided on the command line as the username for the account.
USERNAME="${1}"

# Any remaining arguments on the command line will be treated as the comment for the account.
shift
COMMENT="${@}"

# Generate a password for the new account.
PASSWORD=$(date +%s%N${RANDOM} | sha256sum | head -c8)

# Create the user with the password.
useradd -c "${COMMENT}" -m ${USERNAME} &> /dev/null

# Check to see if the useradd command succeeded.
# If the account is not created, the script is to return an exit status of 1.
# All messages associated with this event will be displayed on standard error.
if [[ "${?}" -ne 0 ]]
then
  echo "ERROR! The account could not be created." >&2
  exit 1
fi

# Set the password.
echo ${PASSWORD} | passwd --stdin ${USERNAME} &> /dev/null

# Check to see if the passwd command succeeded.
# Inform the user if the account was not able to be created for some reason.
if [[ "${?}" -ne 0 ]]
then
  echo "ERROR! The password could not be set." >&2
  exit 1
fi

# Force password change on first login.
passwd -e ${USERNAME} &> /dev/null

# Displays the username, password, and host where the account was created.
echo "SUCCESS! New user account created successfully"
echo "User Name: ${USERNAME}"
echo "Password: ${PASSWORD}"
echo "Hostname: $(hostname)"

exit 0
