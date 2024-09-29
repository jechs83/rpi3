#!/bin/bash

# Variables
OPENVPN_CONFIG="/etc/openvpn/client.conf"
SQUID_CONFIG_SRC="/squid.conf"
SQUID_CONFIG_DEST="/etc/squid/squid.conf"

# Copiar archivos de configuración desde la carpeta raíz al destino apropiado
if [ -f "/client.ovpn" ]; then
    cp /client.ovpn "$OPENVPN_CONFIG"
else
    echo "Error: client.ovpn no se encontró en el directorio raíz."
    exit 1
fi

if [ -f "$SQUID_CONFIG_SRC" ]; then
    # Cambiar el puerto en squid.conf antes de copiarlo
    sed -i "s/http_port .*/http_port ${SQUID_PORT}/" "$SQUID_CONFIG_SRC"
    cp "$SQUID_CONFIG_SRC" "$SQUID_CONFIG_DEST"
else
    echo "Error: squid.conf no se encontró en el directorio raíz."
    exit 1
fi

# Iniciar OpenVPN
echo "Iniciando OpenVPN..."
openvpn --config "$OPENVPN_CONFIG" &

# Iniciar Squid
echo "Iniciando Squid en el puerto ${SQUID_PORT}..."
squid -N -f "$SQUID_CONFIG_DEST"