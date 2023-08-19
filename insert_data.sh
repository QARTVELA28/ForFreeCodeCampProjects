#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

# Reading file and inserting data

echo $($PSQL "TRUNCATE teams, games")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS 

do

  if  [[ $YEAR != "year" ]]
  
  then

    #Get Winner and opponent IDs
    
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT'")
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER'")


    if [[ -z $WINNER_ID || -z $OPPONENT_ID ]];

    #Inserting in to teams

    then

      if [[ -z $WINNER_ID ]]

      then

        INSERT_WINNER_RES=$($PSQL "INSERT INTO teams(name) VALUES ('$WINNER')") 

        if [[ $INSERT_WINNER_RES == "INSERT 0 1" ]]

        then
          echo Inserted team $WINNER
        fi

        WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER'")

      fi

      if [[ -z $OPPONENT_ID ]] 
      then

        INSERT_OPPONENT_RES=$($PSQL "INSERT INTO teams(name) VALUES ('$OPPONENT')")

        if [[ INSERT_OPPONENT_RES == "INSERT 0 1" ]] 

        then
          echo Inserted team $OPPONENT
        fi

        OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT'")

      fi

    fi

    INSERT_GAME_RES=$($PSQL "INSERT INTO games(year,round,winner_id,opponent_id,winner_goals,opponent_goals) VALUES ($YEAR,'$ROUND',$WINNER_ID,$OPPONENT_ID,$WINNER_GOALS,$OPPONENT_GOALS)")

    if [[ $INSERT_GAME_RES == "INSERT 0 1" ]]

    then
      echo Inserted game $YEAR,$ROUND,$WINNER_ID,$OPPONENT_ID,$WINNER_GOALS,$OPPONENT_GOALS
    fi

  fi    

done
