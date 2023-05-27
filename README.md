# Cronicle Docker

Dockerised Cronicle, based on the [Cronicle-Edge](https://github.com/cronicle-edge/cronicle-edge) fork.

Can function in both the **manager** and **worker** role.

## Running 

`config.json`, located in `/config/cronicle/conf/config.json`, is automatically generated on the first run of Cronicle in 'manager' mode. This file must be kept identical between the manager and any workers it controls.

If you want to configure Cronicle before first run (e.g to use a different storage engine), download `config_sample.json` and adjust accordingly before placing in `/config/cronicle/conf/config.json`.

:exclamation: NOTE: You must define the hostname of the container. Cronicle expects the hostname to remain the same, so the randomly-generated container hostname can cause problems if it changes. :exclamation:

### Docker CLI
```
docker run -d --name cronicle \
    --hostname cronicle-manager \
    -p 3012:3012 \
    -e MODE=manager \
    -e PUID=1000 \
    -e PGID=1000 \
    -e TZ=Europe/London \
    -v {path on host}:/config
    git.mrmeeb.stream/mrmeeb/cronicle:latest 
```

### Docker Compose

```
version: '3'
services:
  cronicle:
    container_name: cronicle
    image: git.mrmeeb.stream/mrmeeb/cronicle:latest
    restart: unless-stopped
    hostname: cronicle-manager
    ports:
      - 3012:3012
    volumes:
      - {path on host}:/config
    environment:
      - MODE=manager
      - PUID=1000
      - PGID=1000
      - TZ=Europe/London
```

## Custom Scripts

This container automatically checks for scripts in `/config/init` and runs them at startup. This could be useful if you need to install additional applications into a worker container so it can execute jobs.

## Ports

|Port |Description|
|-----|-----------|
|3012 |WebUI and communication between manager and workers|

## Volumes

|Mount |Description|
|------|-----------|
|/config |Persistent config file and job configurations|

## Environment Variables
|Variable|Options|Default|Description|
|--------|-------|-------|-------|
|MODE    |manager, worker|manager|Determines what mode Cronicle runs in
|PUID    |int    |1000   |Sets the UID of the user Cronicle runs under
|PGID    |int    |1000   |Sets the GID of the user Cronicle runs under
|TZ      |[List of valid TZs](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones#List)    |UTC    |Sets the timezone of the container and by extension Cronicle