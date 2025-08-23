@echo off

docker exec -it dev bash

if errorlevel 1 cls && docker run --rm --name dev --privileged -v c://:/home/bakerface/host -v c://Users/cbaker/.ssh:/home/bakerface/.ssh -e DOCKER_HOST=tcp://localhost:2375 -p 1234:1234 -p 3000:3000 -p 8080:8080 -it bakerface/dev
