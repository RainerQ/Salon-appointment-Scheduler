
#! /bin/bash

#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"
echo -e "\n~~~~~ Salon Appointment Scheduler ~~~~~\n"


MAIN_MENU() {
  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi
  echo "Thank you for coming to Cecilias's Salon!" 
  

  AVAILABLE_SERVICE=$($PSQL "SELECT service_id, name FROM services WHERE available = 't' ORDER BY service_id")
  #echo $AVAILABLE_SERVICE

  #if no service is available
  if [[ -z $AVAILABLE_SERVICE ]]
  then
    MAIN_MENU "Sorry, we don't have any available services right now."
  else
    #display available services
    echo -e "Here are the available services, Please select one:\n"
    echo "$AVAILABLE_SERVICE" | while read SERVICE_ID BAR NAME 
    do
      echo "$SERVICE_ID) $NAME"
      
    done

    #select a valid service number
    read SERVICE_ID_SELECTED

    #if input is not a number
    if [[ ! $SERVICE_ID_SELECTED =~ ^[0-9]+$ ]] || [[ $SERVICE_ID_SELECTED > 7 ]]
    then
      MAIN_MENU "That is not a valid number!!\n"
    else
      #get customer info
      echo -e "What's your phone number?"
      read CUSTOMER_PHONE
      CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")
      NAME_SERV=$($PSQL "SELECT name FROM services WHERE service_id = '$SERVICE_ID_SELECTED'")
      #if customer does not exist
      if [[ -z $CUSTOMER_NAME ]]
      then
        #get new customer name
        echo -e "\nWhat's your name?"
        read CUSTOMER_NAME
        

        #insert new customer name
        INSERT_CUSTOMER=$($PSQL "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE','$CUSTOMER_NAME')")
        
      fi

      #get appointment time
      echo -e "\nWhat's the best time for you to come in?"
      read SERVICE_TIME

      #get customer_id
      CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
      
      if [[ $SERVICE_TIME ]]
      then
        INSERT_APPOINTMENT_TIME=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES('$CUSTOMER_ID','$SERVICE_ID_SELECTED','$SERVICE_TIME')")
        if [[ $INSERT_APPOINTMENT_TIME ]]
        then
          echo -e "\nI have put you down for a $NAME_SERV at $SERVICE_TIME, $CUSTOMER_NAME. "
        fi


      fi
     

      
    


      

    fi

    
    
  fi  


  
}




MAIN_MENU
