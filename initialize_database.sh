#!/bin/bash
###########
#
#  DoneBy AlexanderNTK. I want to believe. 
#
###########
PGHOST_INP=''
PGDATABASE_INP='' 
PGUSER_INP=''
PGPASSWORD_INP=''
SCHEMADIR=''
SCHEMASUFFIXDIR='/database/schema'
DROPDB=''
PSQL=/usr/bin/psql
#Prepare initial data
if [ -z $SCHEMADIR ] 
then
  SCHEMADIR=$(pwd)$SCHEMASUFFIXDIR
fi

if [ -z $DROPDB ] 
then
  read -p "Drop database if exists y/n [n]:" pgdrop
  TMPDROP=${pgdrop:-n}
fi
if [ $TMPDROP == 'y' ] 
then
  DROPDB=true
elif [$TMPDROP == 'n' ]
then
  DROPDB=false
fi
if [ -z $PGHOST_INP ] 
then
  read -p "Postgre host variable is empty please enter[localhost]:" pghostusr
  PGHOST_INP=${pghostusr:-localhost}
fi

if [ -z $PGDATABASE_INP ] 
then
  read -p "Postgre database variable is empty please enter[bigdipper]:" pgdbusr
  PGDATABASE_INP=${pgdbusr:-bigdipper}
fi

if [ -z $PGUSER_INP ] 
then
  read -p "Postgre user variable is empty please enter[postgres]:" pghostusr
  PGUSER_INP=${pghostusr:-postgres}
fi

if [ -z $PGPASSWORD_INP ] 
then
  read -s -p "Please enter postgre password:" pgpwd
  PGPASSWORD_INP=${pgpwd}
  echo "";
fi

export PGHOST=$PGHOST_INP 
export PGUSER=$PGUSER_INP
export PGPASSWORD=$PGPASSWORD_INP
export PGDATABASE='template1'
#Drop database
if [ "$DROPDB" = true ] ; then
   echo "Drop database ${PGDATABASE_INP}"
   $PSQL -q -c "DROP DATABASE IF EXISTS ${PGDATABASE_INP}"
fi
echo "Create database ${PGDATABASE_INP}"
$PSQL -q -c "CREATE DATABASE ${PGDATABASE_INP}"
export PGDATABASE=$PGDATABASE_INP
echo "Upload database schema"
for sqlfile in $SCHEMADIR/*.sql; do
  [ -e "$sqlfile" ] || continue
  $PSQL -q -f "$sqlfile"
done

echo "Database is ready"

exit 0
