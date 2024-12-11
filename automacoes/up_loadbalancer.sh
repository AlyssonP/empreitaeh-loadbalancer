#!/bin/bash

DEFAULTCONF="./default.conf:/etc/nginx/conf.d/default.conf"
NOMECONTAINER="loadbalancer"

docker run -it -d -p 80:80 -v "$DEFAULTCONF" --name "$NOMECONTAINER" nginx:alpine