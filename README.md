# Cronicle Docker

[![Build Status](https://drone.mrmeeb.stream/api/badges/MrMeeb/cronicle-docker/status.svg)](https://drone.mrmeeb.stream/MrMeeb/cronicle-docker) - _Every new commit triggers a build. I'm lazy._


Dockerised Cronicle, based on the [Cronicle-Edge](https://github.com/cronicle-edge/cronicle-edge) fork.

Can function in both the **manager** and **worker** role.

## Running 

`config.json`, located in `/config/config.json`, is automatically generated on the first run of Cronicle in 'manager' mode. This file must be kept identical between the manager and any workers it controls.

If you want to configure Cronicle before first run, download `config_sample.json` and adjust accordingly before placing in `/config/config.json`.

NOTE: You must define the hostname of the container. Cronicle expects the hostname to remain the same, so the randomly-generated container hostname can cause problems if it changes.

### Docker CLI
```
docker run -d --name cronicle \
    --hostname cronicle-manager \
    -p 3012:3012 \
    -e MODE=manager \
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
```

## Custom Scripts

This container automatically checks for scripts in `/config/init` and runs them at startup of the container. This could be useful if you need to install additional applications into a worker container so it can execute any jobs.

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