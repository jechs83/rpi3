#!/bin/bash

# Reemplazar la variable ${SQUID_PORT} en el archivo de configuración de Squid
envsubst < /etc/squid/squid.conf.template > /etc/squid/squid.conf

# Iniciar OpenVPN utilizando la configuración proporcionada
openvpn --config ${OPENVPN_CONFIG} --dev tun &

# Iniciar Squid con la configuración proporcionada
squid -f /etc/squid/squid.conf

# Mantener el contenedor activo
tail -f /dev/null