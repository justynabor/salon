#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=salon --tuples-only -c "
echo -e "\n~~~~~ HAIR SALON~~~~~\n"
echo -e "\nWelcome to our hairsalon! How can we help you?\n"

MAIN_MENU(){
  
  SERVICES=$($PSQL "SELECT * FROM services")
  echo "$(echo $SERVICES | sed 's/ |/)/g')"
  read SERVICE_ID_SELECTED
  SERVICE_ID=$($PSQL "SELECT service_id FROM services WHERE service_id = $SERVICE_ID_SELECTED" )

  if [[ -z $SERVICE_ID ]]
  then
    echo -e "\nSorry, we don't provide the chosen service. Please choose once again"
    MAIN_MENU 
  else
    echo -e "\nWhat's your phone number"
    read CUSTOMER_PHONE
    PHONE=$($PSQL "SELECT phone FROM customers WHERE phone = '$CUSTOMER_PHONE'" )
    if [[ -z $PHONE ]]
      then
      echo -e "\nI don't have a record for that phone number, what's your name?"
      read CUSTOMER_NAME
      INSERTING_NAME_PHONE=$($PSQL "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE', '$CUSTOMER_NAME')" )
      else 
      CUSTOMER_NAME =$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'" )
      fi
    echo -e "\nWhat time would you like your cut, $CUSTOMER_NAME?"
    read SERVICE_TIME
    GET_CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")
    GET_SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED")
    INSERTING_APPOINTMENT=$($PSQL "INSERT INTO appointments(time, service_id, customer_id) VALUES('$SERVICE_TIME',$SERVICE_ID_SELECTED, $GET_CUSTOMER_ID)")
    echo -e "\nI have put you down for a$GET_SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."

  fi

}
MAIN_MENU
