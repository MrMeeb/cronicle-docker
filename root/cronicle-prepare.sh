#!/command/with-contenv bash
# shellcheck shell=bash

echo "Preparing Cronicle"

#Importing and running additional scripts placed in /config/init
if [ -d /config/init ]
then
	if [ "$(ls -A /config/init)" ]
    then

        echo "Running additional startup scripts."

        bash /config/init/*
	
    else
        
        echo "/config/init is empty - no additional startup scripts detected."
	
    fi
else

	echo "Directory /config/init not found. Creating."

    mkdir /config/init

fi

if [ ! -d /config/cronicle ]
then
    echo "Directory /config/cronicle not found. Creating."

    mkdir /config/cronicle
fi

#Detecting what mode Cronicle should be started in
if [ $MODE == "manager" ] 
then

    echo "Cronicle is running in 'manager' mode."

    #Copying config directory to /config/cronicle/conf if not already there, then linking back into Cronicle
    if [ ! -d /config/cronicle/conf ]
    then
        cp -r /app/cronicle/conf /config/cronicle/conf
        rm -rf /app/cronicle/conf
        ln -s /config/cronicle/conf /app/cronicle/conf
    fi

    if [ ! -f /config/cronicle/data/.setup_done ]
    then

        echo "Setup needed - running now."

        /app/cronicle/bin/control.sh setup
        touch /app/cronicle/data/.setup_done

        #Moving data dir to /config, then linking it back into Cronicle
        mv -n /app/cronicle/data /config/cronicle/data
        rm -rf /app/cronicle/data
        ln -s /config/cronicle/data /app/cronicle/data

        #exec node /app/cronicle/lib/main.js --color 1

    else

        echo "Setup already completed."

        rm -rf /app/cronicle/data
        ln -s /config/cronicle/data /app/cronicle/data

        #exec node /app/cronicle/lib/main.js --color 1

    fi

elif [ $MODE == "worker" ] 
then

    echo "Cronicle is running in 'worker' mode."

    if [ ! -f /config/cronicle/conf/config.json ]
    then

        echo "No config found. Copy config.json from the manager server and place it in /config/cronicle/conf dir."
        mkdir -p /config/cronicle/conf
        exit 0

    else

        #Removing default config.json and linking provided one back into Cronicle
        rm -rf /app/cronicle/conf/config.json
        ln -s /config/config.json /app/cronicle/conf/config.json

        #exec node /app/cronicle/lib/main.js --color 1

    fi

else

    echo "'$MODE' is not a recognised appion for the MODE environment variable. Accepted appions are 'manager' and 'worker'."

fi

#echo "Applying permissions to /config and /app (this can take a while on first run or after PUID/PGID changes)"
#chmod "=rwx" /config
#chown -R mrmeeb:mrmeeb /config
#chown -R mrmeeb:mrmeeb /app