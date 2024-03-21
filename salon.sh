#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

MENU() {
  
  if [[ $1 ]]
  then
  
   echo -e "\n$1"
  
  fi

  echo -e "Available services for an appointment."
  SERVICES=$($PSQL "SELECT * FROM services ORDER BY service_id") 
  echo "$SERVICES" | while read SERVICE_ID BAR SERVICE
  do

    echo "$SERVICE_ID) $SERVICE"

  done

  read SERVICE_ID_SELECTED

  SELECTED_SERVICE=$($PSQL "SELECT service_id FROM services WHERE service_id=$SERVICE_ID_SELECTED")

  if [[ -z $SELECTED_SERVICE ]]
  then

    MENU "please choose something else"
  
  else

    echo "for shedule, enter your number"

    read CUSTOMER_PHONE

    CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")

    if  [[ -z $CUSTOMER_ID ]]
    then
      
      echo "lets register and enter your name"

      read CUSTOMER_NAME 

      INSERTED_CUSTOMER=$($PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME','$CUSTOMER_PHONE')")

      CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")

    fi

    CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")

    echo "Time?"

    read SERVICE_TIME

    INSERTED_APPOINTMENT=$($PSQL "INSERT INTO appointments(service_id, customer_id, time) VALUES($SELECTED_SERVICE,$CUSTOMER_ID,'$SERVICE_TIME')")

    SERVICE_FP=$($PSQL "SELECT name FROM services WHERE service_id=$SELECTED_SERVICE")

    echo "I have put you down for a$SERVICE_FP at $SERVICE_TIME,$CUSTOMER_NAME."

  fi

}

MENU
