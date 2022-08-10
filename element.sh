#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

if [[ -z $1 ]]
then
  echo -e "Please provide an element as an argument."
else
  if [[ ! $1 =~ ^[0-9]+$ ]]
  then
    ELEMENT=$($PSQL "select atomic_number, atomic_mass, melting_point_celsius, boiling_point_celsius, symbol, name, type from properties join elements using(atomic_number) join types using(type_id) where elements.name like '$1%' order by atomic_number limit 1")
  else
    ELEMENT=$($PSQL "select atomic_number, atomic_mass, melting_point_celsius, boiling_point_celsius, symbol, name, type from properties join elements using(atomic_number) join types using(type_id) where elements.atomic_number=$1")
  fi
  if [[ ! -z $ELEMENT ]]
  then
    echo $ELEMENT | while IFS=" | " read ATOMIC_NUMBER ATOMIC_MASS MPC BPC SYMBOL NAME TYPE 
    do
      echo -e "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MPC celsius and a boiling point of $BPC celsius."
    done
  else
    echo -e "I could not find that element in the database."
  fi
fi
