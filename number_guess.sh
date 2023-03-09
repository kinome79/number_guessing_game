#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"


#Get and validate username
read -p "Enter your username: " USERNAME

if [[ -z $USERNAME ]]
then
  echo "You must enter a username to play!"
  exit
elif [[ ${#USERNAME} -gt 22 ]]
then
  echo "The username supplied is too long at ${#USERNAME} chars (max 22 chars)!"
  exit
else
  USER_INFO=$($PSQL "SELECT user_id, games_played, best_game FROM users WHERE username='$USERNAME'")
  if [[ -z $USER_INFO ]]
  then
    echo "Welcome, $USERNAME! It looks like this is your first time here."
    RESPONSE=$($PSQL "INSERT INTO users(username) VALUES ('$USERNAME')")
    if [[ $RESPONSE != "INSERT 0 1" ]]
    then
      echo "An error occurred while storing your username!"
    fi
  else
    IFS="|" read ID GAMES BEST <<< "$USER_INFO"
    echo "Welcome back, $USERNAME! You have played $GAMES games, and your best game took $BEST guesses."
  fi
fi

#Generate and echo random number
RANDOM_NUM=$(($RANDOM%1000 + 1))

#Guessing Loop