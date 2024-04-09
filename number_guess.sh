#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"




echo "Enter your username: "


GET_USER () {

 
read USER_NAME

# check if user name < 23 3characters
LEN_NAME=${#USER_NAME}
# echo $LEN_NAME
if [[ ! $LEN_NAME > 22 ]]
then
  echo "Please choose a name shorter than 23 characters:"
  read USER_NAME
fi
# check name exists in database


# check if user exists
USER=$($PSQL "select name from players where name = '$USER_NAME'" )
#echo -e "you are $USER"

if [[ ! $USER ]]
then
  INSERT_RESULT=$($PSQL "insert into players(name) values('$USER_NAME')")
 
   echo -e "\nWelcome, $USER_NAME! It looks like this is your first time here."

 else
  NUM_OF_GAMES=$($PSQL "select count(g.game_date) from games as g join players as p using(player_id) where p.name = '$USER'")
  NUM_OF_GUESSES=$($PSQL "select g.num_of_guesses from games as g join players as p using(player_id) where p.name = '$USER'")
  BEST_GAME=$($PSQL "select min(g.num_of_guesses) from games as g join players as p using(player_id) where (p.name = '$USER' and g.num_of_guesses != 0)")
   echo -e "\nWelcome back, $USER! You have played $NUM_OF_GAMES games, and your best game took $NUM_OF_GUESSES guesses."
fi
   
   PLAYER_ID=$($PSQL "select player_id from players where name = '$USER_NAME'")
  # echo -e "\nyour id is $PLAYER_ID"
   
 
}
GET_USER

NUMBER_OF_GUESSES=0

 # generate a number between 1 and 1000
NUMBER=$(($RANDOM % 1000 + 1))

 START_NEW_GAME=$($PSQL "insert into games(player_id) values($PLAYER_ID) ")
# prompt for guess
echo -e "\nGuess the secret number between 1 and 1000:"
 

GUESS_NUM () {
  
  read GUESS

 GAME_ID=$($PSQL "select game_id from games where player_id = $PLAYER_ID")
  let NUMBER_OF_GUESSES+=1
  UPDATE_NUM_OF__GUESSES=$($PSQL "update games set num_of_guesses = $NUMBER_OF_GUESSES where (player_id = $PLAYER_ID and game_id = $GAME_ID)")
  #echo "you guessed $NUMBER_OF_GUESSES times"
   echo $GAME_ID
  if [[ ! $GUESS =~ ^[0-9]+$ ]]
  then
    echo -e "\nThat is not an integer, guess again:"
    GUESS_NUM 
  fi
  
  # 1 number correct
    if [[ $GUESS == $NUMBER ]]
    then
      echo -e "\nYou guessed it in $NUMBER_OF_GUESSES tries. The secret number was $NUMBER. Nice job!" 
  # 2 number low
    elif [[ $GUESS > $NUMBER ]]
    then
      echo -e "\nIt's lower than that, guess again:"
      GUESS_NUM
  # 3 number high 
    elif [[ $GUESS < $NUMBER ]]
    then
      echo -e "\nIt's higher than that, guess again:"
      GUESS_NUM     
  fi
  
}
GUESS_NUM
