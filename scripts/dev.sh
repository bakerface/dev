#!/bin/bash

clear

docker exec \
  -e COLUMNS=$(tput cols) \
  -e LINES=$(tput lines) \
  -it dev bash 2>/dev/null

if [ $? -ne 0 ]; then
  docker run --rm \
    --name dev \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v $HOME:/home/host \
    -e CHOKIDAR_USEPOLLING=1 \
    -e PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=1 \
    -e REACT_NATIVE_PACKAGER_HOSTNAME=$(ipconfig getifaddr en0) \
    -p 3000:3000 \
    -p 8000:8000 \
    -p 8080:8080 \
    -p 8081:8081 \
    -p 9000:9000 \
    -p 19000:19000 \
    -p 19001:19001 \
    -it bakerface/dev
fi
