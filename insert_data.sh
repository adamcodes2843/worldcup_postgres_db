#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE games, teams")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
if [[ $YEAR != "year" ]]
then

  # get team_id for winner

  TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")

  # if not found

  if [[ -z $TEAM_ID ]]

  # insert team to teamS
  
  then 
    INSERT_WINNER_INTO_TEAMS=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
    if [[ $INSERT_WINNER_INTO_TEAMS == "INSERT 0 1" ]]
    then
      echo Inserted into teams: $WINNER
    fi
  # get new team_id for winner

  TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
  fi

  # get team_id for opponent

    TEAM_ID_2=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")

  # if not found

    if [[ -z $TEAM_ID_2 ]]

  # insert team into teams

    then
      INSERT_OPPONENT_INTO_TEAMS=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
      if [[ $INSERT_OPPONENT_INTO_TEAMS == "INSERT 0 1" ]]
      then
        echo Inserted into teams: $OPPONENT
      fi

  # get new team_id for opponent

    TEAM_ID_2=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    fi

  # insert everything into games

    INSERT_INTO_GAMES=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $TEAM_ID, $TEAM_ID_2, $WINNER_GOALS, $OPPONENT_GOALS)")
    if [[ $INSERT_INTO_GAMES == "INSERT 0 1" ]]
    then
      echo Inserted into games: $YEAR, $ROUND, $TEAM_ID, $TEAM_ID_2, $WINNER_GOALS, $OPPONENT_GOALS
    fi
fi
done
