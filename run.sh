#!/bin/bash

echo $MODE

if [ $MODE == "master" ] 
then
    echo "Cronicle is running in 'master' mode"
elif [ $MODE == "worker" ] 
then
    echo "Cronicle is running in 'worker' mode"
else
    echo "This is not a recognised mode. Accepted options are 'master' and 'worker'"
fi

#/opt/cronicle/bin/control.sh setup

#exec node /opt/cronicle/lib/main.js --color 1