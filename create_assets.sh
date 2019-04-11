#!/bin/bash
####################
#
#
###################


if ! options=$(getopt -o u:d:s: -a -l users:,dbname:,secret: -- "$@") 
then
     echo "Error processing CLI options; exiting."
     exit 1
fi

set -- $options

while [ $# -gt 0 ] ; do
     case $1 in
          -u | --users  ) NUM_USERS=$2 ; shift ;;
          -d | --dbname ) BASE_DB=$2   ; shift ;;
          -s | --secret ) STAGE_AUTH=$2 ; shift ;;
     esac
     shift
done

if [ ! -f $STAGE_AUTH ] ; then
     echo "Could not find file $STAGE_AUTH; exiting."
     exit 1
fi

if [ ! -r $STAGE_AUTH ] ; then
     echo "Could not read file $STAGE_AUTH; exiting."
     exit 1
fi

source $STAGE_AUTH

[[ -d hands_on_assets ]] && rm -rf hands_on_assets

mkdir hands_on_assets

echo "s/DEMO_DBNAME/${BASE_DB}/g" > $$_tmp.sed
echo "s/AWS_KEY_ID_VAL/${AWS_KEY_ID}/g" >> $$_tmp.sed
echo "s/AWS_SECRET_KEY_VAL/${AWS_SECRET_KEY}/g" >> $$_tmp.sed

cat setup/setup.sql | sed -f $$_tmp.sed > hands_on_assets/demo_setup.sql

echo -n "Please enter a password for demo users to login with: "
read PASSWORD_VAL

for DEMO_NUM in `seq 1 ${NUM_USERS}` ; do
     mkdir hands_on_assets/user_${DEMO_NUM}
     echo "s/DEMO_NUM/${DEMO_NUM}/g" > $$_tmp.sed
     echo "s/DEMO_DBNAME/${BASE_DB}/g" >> $$_tmp.sed
     echo "s/PASSWORD_VAL/${PASSWORD_VAL}/g" >> $$_tmp.sed


     for sql in `ls base_sql/*sql` ; do
          cat $sql | sed -f $$_tmp.sed > hands_on_assets/user_${DEMO_NUM}/`basename $sql`          
     done 

     echo "--Initializing environment for demo_user ${DEMO_NUM}" >> hands_on_assets/demo_setup.sql
     cat setup/demo_setup.sql | sed -f $$_tmp.sed >> hands_on_assets/demo_setup.sql
done

rm -rf $$_tmp.*

exit 0

