#!/command/with-contenv bash
# shellcheck shell=bash

echo ""
echo ""
echo "================================================"
echo "|      __  _______  __  ___________________    |" 
echo "|     /  |/  / __ \/  |/  / ____/ ____/ __ )   |"
echo "|    / /|_/ / /_/ / /|_/ / __/ / __/ / __  |   |"
echo "|   / /  / / _, _/ /  / / /___/ /___/ /_/ /    |"
echo "|  /_/  /_/_/ |_/_/  /_/_____/_____/_____/     |"
echo "|                                              |"
echo "================================================"
echo ""
echo "Initialising container"
echo "
----------------------------------------------------------------------
ENVIRONMENT
----------------------------------------------------------------------
PUID=${PUID}
PGID=${PGID}
TZ=${TZ}
MODE=${MODE}
LOG_LEVEL=${LOG_LEVEL}
----------------------------------------------------------------------
"

#Setting UID and GID as configured
if [[ ! "${PUID}" -eq 0 ]] && [[ ! "${PGID}" -eq 0 ]]; then
    echo "Executing usermod..."
    mkdir "/tmp/temphome"
    usermod -d "/tmp/temphome" cronicle
    usermod -o -u "${PUID}" cronicle
    usermod -d /config cronicle
    rm -rf "/tmp/temphome"
    groupmod -o -g "${PGID}" cronicle
else
    echo "Running as root is not supported, please fix your PUID and PGID!"
    exit 1
fi

#Importing and running additional scripts placed in /config/init
if [ -d /config/init ]; then
	if [ "$(ls -A /config/init)" ]; then
        echo "Running additional startup scripts."
        for f in /config/init/*.sh; do
            bash "$f" 
        done
    else
        echo "/config/init is empty - no additional startup scripts detected."
    fi
else
	echo "Directory /config/init not found. Creating."
    mkdir /config/init && chown -R cronicle:cronicle /config/init
fi

echo "Checking permissions in /config and /app."

if [ -n "$(find /app \! -user ${PUID})" ] || [ -n "$(find /app \! -group ${PGID})" ]
then
    echo "Fixing permissions for /app (this can take some time)."
    chown -R cronicle:cronicle /app
fi

if [ -n "$(find /config \! -user ${PUID})" ] || [ -n "$(find /config \! -group ${PGID})" ]
then
    echo "Fixing permissions for /config (this can take some time)."
    chown -R cronicle:cronicle /config
fi