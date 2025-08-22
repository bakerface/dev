#!/bin/sh

docker build $@ -t bakerface/dev .
docker image prune -f
