#!/bin/bash

# Verificar si el dispositivo TUN está disponible
if [ ! -c /dev/net/tun ]; then
    echo "TUN/TAP device is not available. Ensure the container is started with --device /dev/net/tun."
    exit 1
fi

echo "Iniciando OpenVPN..."
openvpn --config /etc/openvpn/client.ovpn &
OPENVPN_PID=$!

# Esperar a que OpenVPN inicie correctamente
sleep 5

if ! kill -0 $OPENVPN_PID > /dev/null 2>&1; then
    echo "Error al iniciar OpenVPN, cerrando el contenedor."
    exit 1
fi

echo "Iniciando Squid..."
squid -N -f /etc/squid/squid.conf
if [ $? -ne 0 ]; then
    echo "Error al iniciar Squid"
    exit 1
fi