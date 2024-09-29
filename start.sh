#!/bin/bash

# Iniciar OpenVPN en segundo plano
echo "Iniciando OpenVPN..."
openvpn --config /etc/openvpn/client.ovpn &

# Esperar a que la interfaz tun se active
while [ ! -d /dev/net/tun ]; do
    echo "Esperando a que se cree /dev/net/tun..."
    sleep 1
done

# Iniciar Squid
echo "Iniciando Squid..."
squid -N -f /etc/squid/squid.conf