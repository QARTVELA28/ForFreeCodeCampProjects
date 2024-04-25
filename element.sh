#! /bin/bash 
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

FUNC() {

  if [[ $1 ]]
  then
    
    #Obtain the Atomic Number
    if [[ ! $1 =~ ^[0-9]+$ ]]
    then
      if [[ $(echo -n $1 | wc -m) > 2 ]]
      then
        ATOMIC_NUM=$($PSQL "SELECT atomic_number FROM elements WHERE name = '$1'")
      else
        ATOMIC_NUM=$($PSQL "SELECT atomic_number FROM elements WHERE symbol = '$1'")
      fi
    else
      ATOMIC_NUM=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number = $1")
    fi

    if [[ -z $ATOMIC_NUM ]]
    then
      echo 'I could not find that element in the database.'
    else

      #Obtain info for final sentens
      NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number = $ATOMIC_NUM")
      SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number = $ATOMIC_NUM")
      TYPE=$($PSQL "SELECT types.type FROM types LEFT JOIN properties ON types.type_id = properties.type_id WHERE properties.atomic_number = $ATOMIC_NUM")
      MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number = $ATOMIC_NUM")
      MELTING=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number = $ATOMIC_NUM")
      BOILING=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number = $ATOMIC_NUM")
      echo "The element with atomic number $ATOMIC_NUM is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
    fi

  else
    echo "Please provide an element as an argument."
  fi
}

FUNC $1
