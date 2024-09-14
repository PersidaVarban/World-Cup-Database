#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE teams, games")
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT W_G O_G
do
 if [[ $WINNER != "winner" ]]
 then
  WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
  OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
  if [[ -z $WINNER_ID ]]
  then
   INSERT_WINNER=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
   WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
  fi
  if [[ -z $OPPONENT_ID ]]
  then
   INSERT_OPPONENT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
   OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
  fi
  WINNER_ID_GAMES=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
  OPPONENT_ID_GAMES=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
  INSERT_GAME=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES('$YEAR', '$ROUND', '$WINNER_ID_GAMES', '$OPPONENT_ID_GAMES', '$W_G', '$O_G')")
 fi
done
