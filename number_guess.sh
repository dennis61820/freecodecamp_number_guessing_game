#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=<database_name> -t --no-align -c"



echo "Enter your username: "
read USER_NAME


# check if user name < 23 3characters
LEN_NAME=${#USER_NAME}
# echo $LEN_NAME
if [[ ! $LEN_NAME > 22 ]]
then
  echo -e "\nPlease choose a name shorter than 23 characters:"
  GET_USER
fi

echo "hello $USER_NAME"
