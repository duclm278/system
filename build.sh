#!/bin/sh
docker rm -f vm > /dev/null 2>&1
docker build -t vm .
docker run -it --memory="2g" "$@" --name vm vm
