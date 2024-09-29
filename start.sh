#!/bin/bash

# Selección de la configuración según la variable CONFIG
if [ "$CONFIG" = "1" ]; then
    echo "Iniciando con la configuración client1.ovpn y squid1.conf"
    openvpn --config /etc/openvpn/client1.conf &
    squid -f /etc/squid/squid1.conf -N
elif [ "$CONFIG" = "2" ]; then
    echo "Iniciando con la configuración client2.ovpn y squid2.conf"
    openvpn --config /etc/openvpn/client2.conf &
    squid -f /etc/squid/squid2.conf -N
else
    echo "Por favor, establece la variable CONFIG (1 o 2)"
    exit 1
fi