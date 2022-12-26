# Cronicle Docker

⚠️ This container is being actively developed and is not ready for use! ⚠️

Dockerised Cronicle, based on the [Cronicle-Edge](https://github.com/cronicle-edge/cronicle-edge) fork.

Can function in both the **master** and **worker** role.

## Running 
### Docker CLI
```
docker run -d --name cronicle \
    -p 3012:3012 \
    -e MODE=master \
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
    environment:
      - MODE=master
```

## Ports
|Port |Purpose   |
|-----|--------- |
|3012 |WebUI     |

## Environment Variables
|Variable|Options|Default|Description|
|--------|-------|-------|-------|
|MODE    |master, worker|master|Determines what mode Cronicle runs in