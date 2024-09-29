#!/bin/bash

# Iniciar OpenVPN utilizando la configuración proporcionada
openvpn --config ${OPENVPN_CONFIG} --dev tun &

# Iniciar Squid con la configuración proporcionada
squid -f /etc/squid/squid.conf

# Mantener el contenedor activo
tail -f /dev/null