#!/bin/bash
git pull origin main

# Cargar variables de entorno desde el archivo .env
source .env

# Desplegar el contenedor 1
docker build --build-arg CONFIG_FILE=$PROXY1_CONFIG_FILE --build-arg OVPN_FILE=$PROXY1_OVPN_FILE -t proxy1 .
docker run -d --name proxy1 --cap-add=NET_ADMIN --device /dev/net/tun -e SQUID_PORT=$PROXY1_PORT -p $PROXY1_PORT:$PROXY1_PORT proxy1



# Desplegar el contenedor 2
docker build --build-arg CONFIG_FILE=$PROXY2_CONFIG_FILE --build-arg OVPN_FILE=$PROXY2_OVPN_FILE -t proxy2 .
docker run -d --name proxy2 --cap-add=NET_ADMIN --device /dev/net/tun -e SQUID_PORT=$PROXY2_PORT -p $PROXY2_PORT:$PROXY2_PORT proxy2
