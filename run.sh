#!/bin/bash

mv -n /opt/cronicle/conf/config.json /config/config.json
rm -rf /opt/cronicle/conf/config.json
ln -s /config/config.json /opt/cronicle/conf/config.json

if [ $MODE == "manager" ] 
then
    echo "Cronicle is running in 'manager' mode"

    if [ ! -f /config/data/.setup_done ]
    then
        echo "Setup needed - running now"

        /opt/cronicle/bin/control.sh setup
        touch /opt/cronicle/data/.setup_done

        mv -n /opt/cronicle/data /config/data
        rm -rf /opt/cronicle/data
        ln -s /config/data /opt/cronicle/data

        exec node /opt/cronicle/lib/main.js --color 1

    else

        rm -rf /opt/cronicle/data
        ln -s /config/data /opt/cronicle/data

        exec node /opt/cronicle/lib/main.js --color 1

    fi

elif [ $MODE == "worker" ] 
then
    echo "Cronicle is running in 'worker' mode"

    exec node /opt/cronicle/lib/main.js --color 1

else
    echo "'$MODE' is not a recognised option for MODE. Accepted options are 'manager' and 'worker'"
fi