#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

RAND() {

  echo "Guess the secret number between 1 and 1000:"

  RAND_NUM=$((1 + $RANDOM % 1000))  
  TRIES=0
  GUESS=0
  
  GAME

}

GAME() {

  read GUESS

  if [[ $GUESS != $RAND_NUM ]]
  then
    
    #If not an integer
    if [[ ! $GUESS =~ ^[0-9]+$ ]]
    then
      
      echo "That is not an integer, guess again:"
      
      GAME 

    fi

    #Higher then 
    if [[ $GUESS -gt $RAND_NUM ]]
    then
      
      echo "It's higher than that, guess again:"

      ((TRIES++))
      
      GAME 

    fi

    #Lower then
    if [[ $GUESS -lt $RAND_NUM ]]
    then

      echo "It's lower than that, guess again:"

      ((TRIES++))

      GAME

    fi

  else

    ((TRIES++))

    echo "You guessed it in $TRIES tries. The secret number was $RAND_NUM. Nice job!"

    INSERT_GAME=$($PSQL "INSERT INTO games(user_id, tries, rand_num) VALUES($USER_ID, $TRIES, $RAND_NUM)")
    
  fi

}

HELLO() {

  echo 'Enter your username:'

  read USERNAME 

  LENGTH=$( echo -n "$USERNAME" | wc -c )

  if [[ $LENGTH -gt 22 ]]
  then

    echo -e "\nUsername's maximum length is 22 character"

    HELLO

  fi

  USER_ID=$($PSQL "SELECT user_id FROM users WHERE name = '$USERNAME'")

  if [[ -z $USER_ID ]]
  then 

    INSERT_USER=$($PSQL "INSERT INTO users(name) VALUES('$USERNAME')")

    USER_ID=$($PSQL "SELECT user_id FROM users WHERE name = '$USERNAME'")

    echo "Welcome, $USERNAME! It looks like this is your first time here."

  else

    GAMES_PLAYED=$($PSQL "SELECT COUNT(user_id) FROM games WHERE user_id = $USER_ID GROUP BY user_id")
    
    BEST_GAME=$($PSQL "SELECT MIN(tries) FROM games WHERE user_id = $USER_ID")

    echo "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."

  fi

  RAND

}

HELLO
#t1
