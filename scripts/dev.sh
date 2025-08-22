#!/bin/bash

docker exec \
  -e COLUMNS=$(tput cols) \
  -e LINES=$(tput lines) \
  -it dev bash 2>/dev/null

if [ $? -ne 0 ]; then
  docker run --rm \
    --name dev \
    --privileged \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v $HOME/.docker:/home/bakerface/.docker \
    -v $HOME/.ssh:/home/bakerface/.ssh \
    -v $HOME:/home/bakerface/host \
    -p 1234:1234 \
    -p 3000:3000 \
    -p 8080:8080 \
    -it bakerface/dev
fi
