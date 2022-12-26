# Cronicle Docker

⚠️ This container is being actively developed and is not ready for use! ⚠️

Dockerised Cronicle, based on the [Cronicle-Edge](https://github.com/cronicle-edge/cronicle-edge) fork.

Can function in both the **manager** and **worker** role.

## Running 

`config.json`, located in `/config/config.json`, is automatically generated on the first run of Cronicle in 'manager' mode. This file must be kept identical between the manager and any workers it controls.

NOTE: You need to define the hostname of the container if using `docker run`. Cronicle expects the hostname to remain the same, so the randomly-generated container hostname can cause problems if it changes. Docker Compose containers inherit their hostname from the `container_name` parameter, but it can also be defined using `hostname: xyz`.

### Docker CLI
```
docker run -d --name cronicle \
    --hostname cronicle-docker \
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
    ports:
      - 3012:3012
    volumes:
      - {path on host}:/config
    environment:
      - MODE=manager
```

## Ports
|Port |Purpose   |
|-----|----------|
|3012 |WebUI and communication between manager and workers|

## Volumes
|Mount |Purpose   |
|-----|-----------|
|/config |Persistent config file and job configurations|

## Environment Variables
|Variable|Options|Default|Description|
|--------|-------|-------|-------|
|MODE    |manager, worker|manager|Determines what mode Cronicle runs in