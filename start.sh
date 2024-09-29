#!/bin/bash

# Variables
OPENVPN_CONFIG="/etc/openvpn/client.conf"
SQUID_CONFIG="/etc/squid/squid.conf"

# Verificar si los archivos de configuración están disponibles
if [ ! -f "$OPENVPN_CONFIG" ]; then
    echo "Error: Archivo de configuración de OpenVPN no encontrado en $OPENVPN_CONFIG."
    exit 1
fi

if [ ! -f "$SQUID_CONFIG" ]; then
    echo "Error: Archivo de configuración de Squid no encontrado en $SQUID_CONFIG."
    exit 1
fi

# Iniciar OpenVPN
echo "Iniciando OpenVPN..."
openvpn --config "$OPENVPN_CONFIG" &

# Iniciar Squid
echo "Iniciando Squid en el puerto ${SQUID_PORT}..."
squid -N -f "$SQUID_CONFIG"