#!/bin/bash

if [ -z "$1" ]; then
    echo "Uso: $0 <numero_de_iteracoes>"
    exit 1
fi

if ! [[ "$1" =~ ^[0-9]+$ ]]; then
    echo "Erro: O argumento deve ser um número inteiro positivo."
    exit 1
fi

ITERACOES=$1
BUILD="./build:/usr/share/nginx/html/"
APP="./app.conf:/etc/nginx/conf.d/default.conf"
NGINGCONF="./nginx.conf:/etc/nginx/nginx.conf"


for (( i=1; i<=ITERACOES; i++ ))
do
    CONTAINER_NAME="node$i"
    echo "Iniciando contêiner: $CONTAINER_NAME"
    docker run -d -p 80 -v "$BUILD" -v "$NGINGCONF" -v "$APP" --name "$CONTAINER_NAME" --hostname "$CONTAINER_NAME" nginx:alpine
done