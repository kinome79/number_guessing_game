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

VALIDATE_GUESS() {
  while [[ ! $GUESS =~ ^[0-9]+$ ]]
  do
    read -p "That is not an integer, guess again: " GUESS
  done
}

#Guessing Loop
NUM_GUESSES=1
read -p "Guess the secret number between 1 and 1000: " GUESS
VALIDATE_GUESS
while [[ $RANDOM_NUM -ne $GUESS ]]
do
  if [[ $RANDOM_NUM -gt $GUESS ]]
  then
    read -p "It's higher than that, guess again: " GUESS
  else
    read -p "It's lower than that, guess again: " GUESS
  fi
  VALIDATE_GUESS
  (( NUM_GUESSES++ ))
done

(( GAMES++ ))
if [[ $BEST > $NUM_GUESSES ]] 
then
  BEST=$NUM_GUESSES
fi

RESPONSE=$($PSQL "UPDATE users SET games_played=$GAMES, best_game=$BEST WHERE username='$USERNAME'")
if [[ $RESPONSE != "UPDATE 1" ]]
then
  echo "An error occurred while storing your game data!"
fi

echo "You guessed it in $NUM_GUESSES tries. The secret number was $RANDOM_NUM. Nice job!