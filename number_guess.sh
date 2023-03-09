#!/bin/bash

<<<<<<< HEAD
PSQL="psql --username=freecodecamp ==dbname=number_guess -t --no-align -c"
=======

>>>>>>> feat:Initial username validation edit

#Get and validate username
read -p "Enter your username: " USERNAME

if [[ -z $USERNAME ]]
then
  echo "You must enter a username to play!"
elif [[ ${#USERNAME} > 22 ]]
then
  echo "The username supplied is too long (max 22 chars)!"
else

fi

#Generate and echo random number
RANDOM_NUM=$(($RANDOM%1000 + 1))

#Guessing Loop