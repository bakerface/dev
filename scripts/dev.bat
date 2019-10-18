@echo off

docker exec -it dev bash

if errorlevel 1 cls && docker run --rm --name dev -v c://:/home/host -v c://Users/cbaker/.ssh:/home/bakerface/.ssh -e DOCKER_HOST=tcp://localhost:2375 -e CHOKIDAR_USEPOLLING=1 -p 3000:3000 -p 8000:8000 -p 8080:8080 -p 8081:8081 -p 9000:9000 -p 19000:19000 -p 19001:19001 -it bakerface/dev
