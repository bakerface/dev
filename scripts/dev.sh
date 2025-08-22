#!/bin/bash

docker exec \
  -e COLUMNS=$(tput cols) \
  -e LINES=$(tput lines) \
  -it dev bash &>/dev/null

if [ $? -ne 0 ]; then
  docker run --rm \
    --name dev \
    --privileged \
    --net=host \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v $HOME/.docker:/home/bakerface/.docker \
    -v $HOME/.ssh:/home/bakerface/.ssh \
    -v $HOME:/home/bakerface/host \
    -it bakerface/dev
fi
