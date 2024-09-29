#!/bin/bash
# Iniciar OpenVPN utilizando client.conf
openvpn --config /etc/openvpn/client.conf &
# Configurar el puerto dinámico de Squid
sed -i "s/^http_port .*/http_port ${SQUID_PORT}/" /etc/squid/squid.conf
# Iniciar Squid
service squid start
# Mantener el contenedor activo
tail -f /dev/null