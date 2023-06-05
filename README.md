# Cronicle Docker

![Drone (self-hosted) with branch](https://img.shields.io/drone/build/MrMeeb/cronicle-docker/main?label=latest&server=https%3A%2F%2Fdrone.mrmeeb.stream&style=for-the-badge) ![Drone (self-hosted) with branch](https://img.shields.io/drone/build/MrMeeb/cronicle-docker/develop?label=develop&server=https%3A%2F%2Fdrone.mrmeeb.stream&style=for-the-badge)

Dockerised Cronicle, based on the [Cronicle-Edge](https://github.com/cronicle-edge/cronicle-edge) fork of [Cronicle](https://github.com/jhuckaby/Cronicle). This container was built to include features I value in containers, namely logging to `stdout` and configurable `PUID` and `PGID`.

This container can function in both the **manager** and **worker** role.

## Links
- :tea: [Gitea Repo (source)](https://git.mrmeeb.stream/MrMeeb/cronicle-docker)
- :whale2: [Containers](https://git.mrmeeb.stream/MrMeeb/-/packages/container/cronicle/latest) (also published to GHCR)
- :mirror: [GitHub mirror](https://github.com/MrMeeb/cronicle-docker)
- :package: [Cronicle Repo](https://github.com/jhuckaby/Cronicle)
- :package: [Cronicle-Edge Repo](https://github.com/cronicle-edge/cronicle-edge)

*This repo is mirrored to GitHub*

## Overview

[**Cronicle**](https://github.com/jhuckaby/Cronicle) is a multi-server task scheduler and runner, with a web based front-end UI.  It handles both scheduled, repeating and on-demand jobs, targeting any number of worker servers, with real-time stats and live log viewer.  It's basically a fancy [Cron](https://en.wikipedia.org/wiki/Cron) replacement written in [Node.js](https://nodejs.org/).  You can give it simple shell commands, or write Plugins in virtually any language.

![Main Screenshot](https://pixlcore.com/software/cronicle/screenshots-new/job-details-complete.png)

## Features at a Glance

* Single or multi-server setup.
* Automated failover to backup servers.
* Auto-discovery of nearby servers.
* Real-time job status with live log viewer.
* Plugins can be written in any language.
* Schedule events in multiple timezones.
* Optionally queue up long-running events.
* Track CPU and memory usage for each job.
* Historical stats with performance graphs.
* Simple JSON messaging system for Plugins.
* Web hooks for external notification systems.
* Simple REST API for scheduling and running events.
* API Keys for authenticating remote apps.

## Tags

|Tag    |Description|
|-------|-----------|
|latest |Latest image built from the main branch. Usually coincides with a tagged release.|
|develop|Latest image built from the develop branch. Commits are made to the develop branch before being merged to main. Old versions of `develop` are removed after 14 days.|

Tags relating to releases are also available, for locking in on a specific version.

## Running 

`config.json`, located in `/config/cronicle/conf/config.json`, is automatically generated on the first run of Cronicle in 'manager' mode. This file must be kept identical between the manager and any workers it controls.

If you want to configure Cronicle before first run (e.g to use a different storage engine), download `config_sample.json` and adjust accordingly before placing in `/config/cronicle/conf/config.json`. Make sure to change the `secret`!

:exclamation: You must define the hostname of the container. Cronicle expects the hostname to remain the same, so the randomly-generated container hostname can cause problems if it changes. :exclamation:

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
|LOG_LEVEL|1-10  |9      |Sets log level from `1` (quietest) to `10` (loudest)|
