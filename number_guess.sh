#!/bin/bash

PSQL="psql --username=freecodecamp ==dbname=number_guess -t --no-align -c"

#Get and validate username
read -p "Enter your username: " USERNAME

if [[ -z $USERNAME ]]
then
else
fi

#Generate and echo random number
RANDOM_NUM=$(($RANDOM%1000 + 1))

#Guessing Loop