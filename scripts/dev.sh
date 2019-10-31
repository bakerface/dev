#!/bin/bash

docker exec \
  -e COLUMNS=$(tput cols) \
  -e LINES=$(tput lines) \
  -it dev bash 2>/dev/null

if [ $? -ne 0 ]; then
  docker run --rm \
    --name dev \
    --privileged \
    --net=host \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v $HOME:/home/host \
    -v $HOME/.docker:/home/bakerface/.docker \
    -v $HOME/.ssh:/home/bakerface/.ssh \
    -e CHOKIDAR_USEPOLLING=1 \
    -e PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=1 \
    -it bakerface/dev
fi
