#!/bin/bash

# Variables
OPENVPN_CONFIG="/etc/openvpn/client.conf"
SQUID_CONFIG="/etc/squid/squid.conf"
SQUID_CACHE_DIR="/var/spool/squid"

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

# Esperar un momento para asegurarse de que OpenVPN se inicie
sleep 5

# Crear el directorio de caché de Squid si no existe y dar los permisos adecuados
echo "Creando el directorio de caché de Squid..."
mkdir -p $SQUID_CACHE_DIR
chown -R proxy:proxy $SQUID_CACHE_DIR

# Inicializar el directorio de caché
echo "Inicializando el directorio de caché de Squid..."
squid -z -f "$SQUID_CONFIG"
if [ $? -ne 0 ]; then
    echo "Error al inicializar el directorio de caché de Squid"
    cat /var/log/squid/cache.log
    exit 1
fi

# Esperar un momento para que se complete la inicialización del caché
sleep 5

# Iniciar Squid y redirigir los logs a la salida estándar
echo "Iniciando Squid en el puerto ${SQUID_PORT}..."
squid -N -f "$SQUID_CONFIG" || {
    echo "Error al iniciar Squid"
    echo "Logs de Squid:"
    cat /var/log/squid/cache.log
    exit 1
}