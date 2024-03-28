#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

SECRET_NUMBER=$(( RANDOM % 1000 + 1))

echo "Enter your username:"
read USERNAME

USERNAME_RESULT=$($PSQL "SELECT username FROM number_guess WHERE username = '$USERNAME'")
if [[ -z $USERNAME_RESULT ]]
then
  echo "Welcome, $USERNAME! It looks like this is your first time here."
else
  GAMES_PLAYED=$($PSQL "SELECT COUNT(*) FROM number_guess WHERE username = '$USERNAME'")
  BEST_GAME=$($PSQL "SELECT MIN(number_of_guesses) FROM number_guess WHERE username ='$USERNAME'")
  echo "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
fi

NUMBER_OF_GUESSES=0

GET_GUESS(){
  read GUESS
  ((NUMBER_OF_GUESSES++))
  if [[ $GUESS == $SECRET_NUMBER ]]
  then
    ADD_RESULT=$($PSQL "INSERT INTO number_guess(number_of_guesses, username) VALUES($NUMBER_OF_GUESSES, '$USERNAME')")  
    echo You guessed it in $NUMBER_OF_GUESSES tries. The secret number was $SECRET_NUMBER. Nice job\!  
    exit
  fi 
  if [[ ! $GUESS =~ ^[0-9]+$ ]] 
  then
    echo "That is not an integer, guess again:"
    return
  fi
  if [[ $GUESS < $SECRET_NUMBER ]]
  then
    echo "It's higher than that, guess again:"
    return
  fi
  if [[ $GUESS > $SECRET_NUMBER ]]
  then
    echo "It's lower than that, guess again:"
    return
  fi
}

echo "Guess the secret number between 1 and 1000:"

until [[ 1 == 0 ]]
do
  GET_GUESS
done

